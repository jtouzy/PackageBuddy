//
//  SwiftPackage+Dependency.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 07/09/2021.
//

import PathKit

extension SwiftPackage {
  enum Dependency: Codable {
    struct Local: Codable {
      let location: FileLocation
    }
    struct Remote: Codable {
      let name: String
      let location: String
    }
    case local(Local)
    case remote(Remote)

    public var name: String {
      switch self {
      case .local(let local):
        return local.location.name
      case .remote(let remote):
        return remote.name
      }
    }
  }
}

extension SwiftPackage.Dependency {
  public static func local(path: Path) -> Self {
    .local(
      .init(
        location: .init(path: path)
      )
    )
  }
}
