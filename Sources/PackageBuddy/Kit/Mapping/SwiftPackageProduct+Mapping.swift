//
//  SwiftPackageProduct.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PackageModel

extension SwiftPackage.Product {
  enum MappingError: Error {
    case productTargetIsMissingFromManifestTargets(name: String)
  }
}

extension SwiftPackage.Product {
  static func build(
    from productDescription: ProductDescription,
    targets: [SwiftPackage.Target]
  ) throws -> Self {
    .init(
      name: productDescription.name,
      targets: try productDescription.targets.map { productTargetName in
        guard let target = targets.first(where: { $0.name == productTargetName }) else {
          throw MappingError.productTargetIsMissingFromManifestTargets(name: productTargetName)
        }
        return target
      }
    )
  }
}
