//
//  PackageFinder.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 09/07/2021.
//

import PathKit

struct PackageFinder {
  fileprivate static let fileName = "Package.swift"

  static func findAll(inPath path: Path) throws -> [FileLocation] {
    try walkAndFind(inPath: path)
  }
}

private func walkAndFind(inPath path: Path) throws -> [FileLocation] {
  guard path.isDirectory else {
    if path.lastComponent == PackageFinder.fileName {
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
