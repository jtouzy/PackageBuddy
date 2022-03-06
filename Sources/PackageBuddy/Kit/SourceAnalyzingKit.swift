//
//  SourceAnalyzingKit.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PathKit

// ========================================================================
// MARK: SourceAnalyzingKit
// All tools related to source analysis.
// ========================================================================

struct SourceAnalyzingKit {
  typealias FindSourceImports = (Path) throws -> Set<String>

  let findSourceImports: FindSourceImports

  private init(
    findSourceImports: @escaping FindSourceImports
  ) {
    self.findSourceImports = findSourceImports
  }
}

// ========================================================================
// MARK: Live implementation
// ========================================================================

extension SourceAnalyzingKit {
  static var live: Self {
    .init(
      findSourceImports: findSourceImportsLive()
    )
  }
}

private func findSourceImportsLive() -> SourceAnalyzingKit.FindSourceImports {
  return { projectPath in
    try walkAndFind(inPath: projectPath)
  }
}

private func walkAndFind(inPath path: Path) throws -> Set<String> {
  guard path.isDirectory else {
    if path.lastComponent.hasSuffix(".swift") {
      let sourceContent: String = try path.read()
      let imports: [String] = sourceContent.split(separator: "\n").reduce(into: []) { imports, nextLine in
        let trimmedLine = nextLine.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedLine.starts(with: "import ") {
          imports.append(trimmedLine.replacingOccurrences(of: "import ", with: ""))
        }
      }
      return Set(imports)
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
  var packages: Set<String> = .init()
  try path.children().forEach { subPath in
    let resultsForSubPath = try walkAndFind(inPath: subPath)
    resultsForSubPath.forEach { packages.insert($0) }
  }
  return packages
}
