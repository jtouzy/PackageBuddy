//
//  PackageFindingKit.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PathKit

// ========================================================================
// MARK: PackageFindingKit
// All tools related to discover packages in a directory.
// ========================================================================

struct PackageFindingKit {
  typealias FindProjectPackages = (Path) throws -> [FileLocation]

  let findProjectPackages: FindProjectPackages

  private init(
    findProjectPackages: @escaping FindProjectPackages
  ) {
    self.findProjectPackages = findProjectPackages
  }
}

// ========================================================================
// MARK: Live implementation
// ========================================================================

extension PackageFindingKit {
  enum Live {
    static let fileName = "Package.swift"
    static let logger = Logger.make("PackageFinder")
  }

  static var live: Self {
    .init(
      findProjectPackages: findProjectPackagesLive()
    )
  }
}

private func findProjectPackagesLive() -> PackageFindingKit.FindProjectPackages {
  return { projectPath in
    PackageFindingKit.Live.logger.print("Searching packages in project directory...")
    let result = try walkAndFind(inPath: projectPath)
    PackageFindingKit.Live.logger.print("\("\(result.count)".bold) packages found.")
    return result
  }
}

private func walkAndFind(inPath path: Path) throws -> [FileLocation] {
  guard path.isDirectory else {
    if path.lastComponent == PackageFindingKit.Live.fileName {
      let parentPath = path.parent()
      return [.init(path: parentPath)]
    }
    return []
  }
  guard
    // NOTE: Eliminate build directories
    path.lastComponent != ".build",
    // NOTE: Eliminate XCTemplates
    path.lastComponent.starts(with: "___") == false
  else {
    return []
  }
  var packages: [FileLocation] = []
  try path.children().forEach { subPath in
    let resultsForSubPath = try walkAndFind(inPath: subPath)
    packages.append(contentsOf: resultsForSubPath)
  }
  return packages
}
