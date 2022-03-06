//
//  Tree.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import ArgumentParser

///
/// Buddy's `tree` command.
/// This command displays a tree hierarchy of your SPM modules.
///
struct Tree: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "This command displays a tree hierarchy of your SPM modules.",
    subcommands: [Basic.self, Mermaid.self]
  )
}

extension Tree {
  struct Options: ParsableArguments {
    @Option(name: [.customShort("p"), .customLong("project-path")])
    var projectPathString: String
    @Option(name: [.customShort("m"), .customLong("module")])
    var moduleName: String?
    @Option(name: [.customShort("d"), .customLong("depth")])
    var depth: Int?
  }
}
