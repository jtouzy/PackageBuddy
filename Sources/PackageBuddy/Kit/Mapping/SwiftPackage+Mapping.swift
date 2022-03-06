//
//  SwiftPackage+Mapping.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PackageModel

extension SwiftPackage {
  static func build(from manifest: Manifest, location: FileLocation) throws -> Self {
    let dependencies = try manifest.dependencies.map(Dependency.build(from:))
    let targets = try manifest.targets.map {
      try Target.build(from: manifest, target: $0, using: dependencies)
    }
    return .init(
      location: location,
      dependencies: dependencies,
      products: try manifest.products.map { try .build(from: $0, targets: targets) }
    )
  }
}
