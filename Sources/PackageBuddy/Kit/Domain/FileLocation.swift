//
//  FileLocation.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 07/09/2021.
//

import PathKit

struct FileLocation: Codable {
  let name: String
  let pathString: String

  init(path: Path) {
    self.name = path.lastComponent
    self.pathString = path.string
  }
}
