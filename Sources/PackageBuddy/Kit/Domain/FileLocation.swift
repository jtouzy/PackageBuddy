//
//  FileLocation.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PathKit

public struct FileLocation: Codable {
  public let name: String
  public let pathString: String

  init(path: Path) {
    self.name = path.lastComponent
    self.pathString = path.string
  }
}
