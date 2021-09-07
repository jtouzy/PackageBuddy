//
//  PackageAnalyzer.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 09/07/2021.
//

import PackageModel
import PackageLoading
import PackageGraph
import PathKit
import Workspace

// ========================================================================
// MARK: PackageAnalyzer
// Analyze directory to find all SPM modules and analyze their content.
// ========================================================================

struct PackageAnalyzer {
  static func analyzeDirectory(atPath path: Path) throws -> [SwiftPackage] {
    try PackageFinder
      .findAll(inPath: path)
      .sorted(by: { $0.name < $1.name })
      .map(analyzePackage(at:))
  }
}

private let swiftCompiler: AbsolutePath = {
  let string: String
#if os(macOS)
  string = try! Process.checkNonZeroExit(args: "xcrun", "--sdk", "macosx", "-f", "swiftc").spm_chomp()
#else
  string = try! Process.checkNonZeroExit(args: "which", "swiftc").spm_chomp()
#endif
  return AbsolutePath(string)
}()

private func analyzePackage(at location: FileLocation) throws -> SwiftPackage {
  print("Analyzing package: \(location.name)...")
  return try resolveFromManifest(at: location)
}

private func resolveFromManifest(at location: FileLocation) throws -> SwiftPackage {
  let path = AbsolutePath(location.pathString)
  let identityResolver = DefaultIdentityResolver()
  let manifest = try tsc_await {
    ManifestLoader.loadRootManifest(
      at: path,
      swiftCompiler: swiftCompiler,
      swiftCompilerFlags: [],
      identityResolver: identityResolver,
      on: .global(),
      completion: $0
    )
  }
  let dependencies = manifest.dependencies.map(\.toDependency)
  let targets = manifest.targets.map { $0.toTarget(dependencies: dependencies) }
  let products = manifest.products.map { $0.toProduct(targets: targets) }
  return .init(
    location: location,
    products: products
  )
}
