//
//  SwiftPackage.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 09/07/2021.
//

import PathKit

struct SwiftPackage: Codable {
  var name: String { location.name }
  let location: FileLocation
  let dependencies: [Dependency]
  let products: [Product]
}

extension SwiftPackage {
  var mainProduct: Product? {
    products.first(where: { $0.name == name })
  }
}
