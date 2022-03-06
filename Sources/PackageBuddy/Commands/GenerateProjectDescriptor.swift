//
//  GenerateProjectDescriptor.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import ArgumentParser
import PathKit
import Foundation

struct GenerateProjectDescriptor: ParsableCommand {
  @Option(
    name: [.customShort("p"), .customLong("project-path")]
  )
  var projectPathString: String
}

extension GenerateProjectDescriptor {
  func run() throws {
    let runner = Runner(
      projectDescriptorKit: .live,
      projectPath: Path(projectPathString)
    )
    try runner.run()
  }
}

// ========================================================================
// MARK: GenerateProjectDescriptor: Runner
// ========================================================================

private extension GenerateProjectDescriptor {
  struct Runner {
    let projectDescriptorKit: ProjectDescriptorKit
    let projectPath: Path
  }
}

extension GenerateProjectDescriptor.Runner {
  func run() throws {
    _ = try projectDescriptorKit.evaluateProjectDescriptor(projectPath, true)
  }
}
