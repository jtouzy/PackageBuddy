//
//  PackageAnalyzingKit.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import Basics
import PackageModel
import PackageLoading
import PackageGraph
import PathKit
import TSCBasic
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

private func analyzePackage(at location: FileLocation) throws -> SwiftPackage {
  PackageAnalyzingKit.Live.logger.print("Analyzing package: \(location.name.bold)...")
  return try resolveFromManifest(at: location)
}

// github.com/apple/swift-package-manager/blob/main/Examples/package-info/Sources/package-info/main.swift
private func resolveFromManifest(at location: FileLocation) throws -> SwiftPackage {
  let path = AbsolutePath(location.pathString)
  let observability = ObservabilitySystem({ print("\($0): \($1)") })
  let workspace = try Workspace(forRootPackage: path)
  let manifest = try tsc_await { completion in
    workspace.loadRootManifest(
      at: path,
      observabilityScope: observability.topScope,
      completion: completion
    )
  }
  return try SwiftPackage.build(from: manifest, location: location)
}
