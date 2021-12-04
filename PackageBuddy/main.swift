//
//  main.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 09/07/2021.
//

import ArgumentParser

struct PackageBuddyCLI: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Your best command line buddy for SPM-based projects.",
    subcommands: [
      CheckImports.self,
      GenerateProjectDescriptor.self,
      ShowDependencyTree.self
    ]
  )
}

Logger.main.welcome()
PackageBuddyCLI.main()
Logger.main.goodbye()
