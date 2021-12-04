//
//  PackageAnalyzingKit.swift
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
// MARK: PackageAnalyzingKit
// All tools related to SPM package analysis.
// ========================================================================

struct PackageAnalyzingKit {
  typealias AnalyzeProjectPath = (Path) throws -> [SwiftPackage]

  let analyzeProjectPath: AnalyzeProjectPath

  private init(
    analyzeProjectPath: @escaping AnalyzeProjectPath
  ) {
    self.analyzeProjectPath = analyzeProjectPath
  }
}

// ========================================================================
// MARK: Live implementation
// ========================================================================

extension PackageAnalyzingKit {
  enum Live {
    typealias FindProjectPackages = (Path) throws -> [FileLocation]
    static let logger = Logger.make("PackageAnalysis")
  }

  static var live: Self {
    createLive(
      findProjectPackages: PackageFindingKit.live.findProjectPackages
    )
  }

  static func createLive(
    findProjectPackages: @escaping Live.FindProjectPackages
  ) -> Self {
    .init(
      analyzeProjectPath: analyzeProjectPathLive(
        findProjectPackages: findProjectPackages
      )
    )
  }
}

private func analyzeProjectPathLive(
  findProjectPackages: @escaping PackageAnalyzingKit.Live.FindProjectPackages
) -> PackageAnalyzingKit.AnalyzeProjectPath {
  return { projectPath in
    try findProjectPackages(projectPath)
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
  PackageAnalyzingKit.Live.logger.print("Analyzing package: \(location.name.bold)...")
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
  let targets = manifest.toTargets(packageDependencies: dependencies)
  let products = manifest.products.map { $0.toProduct(targets: targets) }
  return .init(
    location: location,
    dependencies: dependencies,
    products: products
  )
}
