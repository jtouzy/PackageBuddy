//
//  main.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import ArgumentParser

struct PackageBuddyCLI: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Your best command line buddy for SPM-based projects.",
    version: "0.2.0",
    subcommands: [
      CheckImports.self,
      GenerateProjectDescriptor.self,
      Tree.self
    ]
  )
}

Logger.main.welcome()
PackageBuddyCLI.main()
Logger.main.goodbye()
