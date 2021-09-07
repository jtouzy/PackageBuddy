//
//  main.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 09/07/2021.
//

import ArgumentParser

struct PackageBuddyCLI: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Command line helper for SPM-based projects.",
    subcommands: [GenerateProjectDescriptor.self]
  )
}

PackageBuddyCLI.main()
