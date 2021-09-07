//
//  GenerateProjectDescriptor.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 09/07/2021.
//

import ArgumentParser
import PathKit
import Foundation

struct GenerateProjectDescriptor: ParsableCommand {
  @Option(
    name: [.customShort("p"), .customLong("project-path")]
  )
  var projectPathString: String
  @Option(
    name: [.customShort("d"), .customLong("relative-destination-file")]
  )
  var relativeDestinationFile: String
  @Flag(
    name: [.customLong("pretty")]
  )
  var isPrettyPrinted: Bool = false
}

extension GenerateProjectDescriptor {
  var projectDescriptorEncoder: JSONEncoder {
    let encoder = JSONEncoder()
    if isPrettyPrinted {
      encoder.outputFormatting = .prettyPrinted
    }
    return encoder
  }
}

extension GenerateProjectDescriptor {
  func run() throws {
    let projectPath = Path(projectPathString)
    print("Path: \(projectPath.string)")
    guard projectPath.exists else {
      throw Error.unreachableProjectPath
    }
    let destinationPath = projectPath + Path(relativeDestinationFile)
    print("Destination file: \(destinationPath.string)")
    print("Will be pretty printed: \(isPrettyPrinted)")
    let packages = try PackageAnalyzer.analyzeDirectory(atPath: projectPath)
    let encodedPackages = try projectDescriptorEncoder.encode(packages)
    try destinationPath.write(encodedPackages)
  }
}

extension GenerateProjectDescriptor {
  enum Error: Swift.Error {
    case unreachableProjectPath
  }
}
