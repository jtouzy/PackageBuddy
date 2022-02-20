//
//  SwiftPackage+Product.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 07/09/2021.
//

extension SwiftPackage {
  struct Product: Codable {
    let name: String
    let targets: [Target]
  }
}

extension SwiftPackage {
  struct Target: Codable {
    let name: String
    let dependencies: [Dependency]
  }
}

extension SwiftPackage.Target {
  enum Dependency: Codable {
    struct Local: Codable {
      let location: FileLocation
    }
    struct Module: Codable {
      let name: String
    }
    struct Remote: Codable {
      let gitName: String
      let targetName: String
      let location: String
    }
    case local(Local)
    case module(Module)
    case remote(Remote)

    public var name: String {
      switch self {
      case .local(let local):
        return local.location.name
      case .module(let module):
        return module.name
      case .remote(let remote):
        return remote.targetName
      }
    }
  }
}
