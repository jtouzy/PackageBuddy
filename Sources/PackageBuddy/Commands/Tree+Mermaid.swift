//
//  Tree+Mermaid.swift
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
  struct Mermaid: ParsableCommand {
    @OptionGroup var options: Options
  }
}

// ========================================================================
// MARK: Runner declaration & invocation
// ========================================================================

extension Tree.Mermaid {
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

extension Tree.Mermaid.Runner {
  fileprivate static let logger = Logger.make("Tree[Mermaid]")

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
    let graphString = projectDescriptor.makeMermaidGraphString(for: packages)
    let mermaidGraph = "```mermaid\ngraph TB;\n\(graphString)\n```\n"
    Self.logger.print("Here is your mermaid tree: \n\n\(mermaidGraph)")
    Self.logger.print("Just copy/paste to a markdown file to see your graph.")
  }
}

private extension Array where Element == SwiftPackage {
  func makeMermaidGraphString(for packages: [SwiftPackage]) -> String {
    Set(makeMermaidGraph(for: packages, format: \.mainBox, link: "==>")).joined(separator: "\n")
  }
  func makeMermaidGraph(
    for packages: [SwiftPackage],
    format: @escaping (String) -> String = \.box,
    link: String = "-->"
  ) -> [String] {
    packages.reduce(into: []) { graph, package in
      package.products.flatMap(\.targets).forEach { target in
        // NOTE: First, use only package-related dependencies
        let packageDependencies = target.dependencies.compactMap(package.dependencies.find(fromTargetDependency:))
        graph.append(contentsOf: packageDependencies.map { "\(format(target.name))\(link)\($0.graphValue);" })
        // NOTE: Then, iterate over all local packages to build their graph
        let linkedLocalSwiftPackages = target.dependencies.compactMap(findLocal(fromTargetDependency:))
        graph.append(contentsOf: makeMermaidGraph(for: linkedLocalSwiftPackages))
      }
    }
  }
}

private extension SwiftPackage.Dependency {
  var graphValue: String {
    "\(displayName)(\(displayName)\(requirement.map { " - \($0.readableVersion)" } ?? ""))"
  }
}

private extension String {
  var box: String {
    "\(self)(\(self))"
  }
  var mainBox: String {
    "\(self){{\(self)}}"
  }
}
