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
