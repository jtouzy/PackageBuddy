//
//  SwiftPM+Mapping.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 10/07/2021.
//

import PackageModel
import PathKit

extension PackageDependencyDescription {
  var toDependency: SwiftPackage.Dependency {
    switch self {
    case .local(let local):
      return .local(
        path: Path(local.path.pathString)
      )
    case .scm(let sourceControlRepository):
      return .remote(
        .init(
          name: sourceControlRepository.location
        )
      )
    }
  }
}

extension ProductDescription {
  func toProduct(targets: [SwiftPackage.Target]) -> SwiftPackage.Product {
    .init(
      name: name,
      targets: self.targets.compactMap { targetName in
        targets.first(where: { $0.name == targetName })
      }
    )
  }
}

extension TargetDescription {
  func toTarget(dependencies: [SwiftPackage.Dependency]) -> SwiftPackage.Target {
    .init(
      name: name,
      dependencies: self.dependencies.compactMap { dependency in
        switch dependency {
        case .byName(let name, _):
          return dependencies.first(where: { $0.name == name })
        case .product(_, _, _):
          // TODO: Handle product dependencies
          return .none
        case .target(_, _):
          // TODO: Handle target dependencies
          return .none
        }
      }
    )
  }
}
