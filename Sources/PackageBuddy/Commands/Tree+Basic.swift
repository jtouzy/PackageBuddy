//
//  Tree+Basic.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import ArgumentParser
import PathKit

// ========================================================================
// MARK: Command definition
// ========================================================================

extension Tree {
  struct Basic: ParsableCommand {
    @OptionGroup var options: Options
  }
}

// ========================================================================
// MARK: Runner declaration & invocation
// ========================================================================

extension Tree.Basic {
  struct Runner {
    let projectDescriptorKit: ProjectDescriptorKit
    let projectPath: Path
    let moduleName: String?
    let depth: Int?
  }

  func run() throws {
    let runner = Runner(
      projectDescriptorKit: .live,
      projectPath: Path(options.projectPathString),
      moduleName: options.moduleName,
      depth: options.depth
    )
    try runner.run()
  }
}

// ========================================================================
// MARK: Running command
// ========================================================================

extension Tree.Basic.Runner {
  fileprivate static let logger = Logger.make("Tree[Basic]")

  func run() throws {
    let projectDescriptor = try projectDescriptorKit.evaluateProjectDescriptor(projectPath, false)
    let packages: [SwiftPackage] = {
      if let moduleName = moduleName {
        if let destinationPackage = projectDescriptor.first(where: { $0.name == moduleName }) {
          return [destinationPackage]
        }
        return []
      }
      return projectDescriptor
    }()
    packages.forEach { package in
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
  Tree.Basic.Runner.logger.print("\("[\(package.name)]".yellow.bold) package: Dependency tree")
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
    .sorted(by: { $0.displayName < $1.displayName })
    .forEach { dependency in
      let indent = Array(repeating: "  ", count: level).joined()
      Tree.Basic.Runner.logger.print("\(indent)↳ \(dependency.displayName)")
      if let dependencyPackage = packages.findLocal(fromTargetDependency: dependency) {
        printPackageTree(
          dependencyPackage,
          in: packages,
          depth: depth,
          level: level + 1
        )
      }
    }
}
