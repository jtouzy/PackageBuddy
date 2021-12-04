//
//  ShowDependencyTree.swift
//  ShowDependencyTree
//
//  Created by Jérémy Touzy on 10/09/2021.
//

import ArgumentParser
import PathKit
import Foundation

struct ShowDependencyTree: ParsableCommand {
  @Option(
    name: [.customShort("p"), .customLong("project-path")]
  )
  var projectPathString: String
  @Option(
    name: [.customShort("m"), .customLong("module")]
  )
  var moduleName: String?
  @Option(
    name: [.customShort("d"), .customLong("depth")]
  )
  var depth: Int?
}

extension ShowDependencyTree {
  func run() throws {
    let runner = Runner(
      projectDescriptorKit: .live,
      projectPath: Path(projectPathString),
      moduleName: moduleName,
      depth: depth
    )
    try runner.run()
  }
}

// ========================================================================
// MARK: ShowDependencyTree: Runner
// ========================================================================

private extension ShowDependencyTree {
  struct Runner {
    let projectDescriptorKit: ProjectDescriptorKit
    let projectPath: Path
    let moduleName: String?
    let depth: Int?
  }
}

extension ShowDependencyTree.Runner {
  fileprivate static let logger = Logger.make("ShowDependencyTree")

  func run() throws {
    let projectDescriptor = try projectDescriptorKit.evaluateProjectDescriptor(projectPath, false)
    let destinationPackages: [SwiftPackage] = {
      if let moduleName = moduleName {
        if let destinationPackage = projectDescriptor.first(where: { $0.name == moduleName }) {
          return [destinationPackage]
        }
        return []
      }
      return projectDescriptor
    }()
    destinationPackages.forEach { package in
      printPackageHeader(package)
      printPackageTree(
        package,
        in: projectDescriptor,
        depth: depth
      )
    }
  }
}

private func printPackageHeader(_ package: SwiftPackage) {
  ShowDependencyTree.Runner.logger.print("\("[\(package.name)]".yellow.bold) package: Dependency tree")
}
private func printPackageTree(
  _ package: SwiftPackage,
  in packages: [SwiftPackage],
  depth: Int?,
  level: Int = 0
) {
  if let depth = depth, level > depth {
    return
  }
  package
    .mainProduct?
    .targets
    .first(where: { $0.name == package.name })?
    .dependencies
    .sorted(by: { $0.name < $1.name })
    .forEach { dependency in
      let indent = Array(repeating: "  ", count: level).joined()
      ShowDependencyTree.Runner.logger.print("\(indent)↳ \(dependency.name)")
      if let dependencyPackage = packages.first(where: { $0.name == dependency.name }) {
        printPackageTree(
          dependencyPackage,
          in: packages,
          depth: depth,
          level: level + 1
        )
      }
    }
}
