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
  let products: [Product]
}
