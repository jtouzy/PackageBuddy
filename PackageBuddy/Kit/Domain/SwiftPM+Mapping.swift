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
          name: sourceControlRepository.name ?? sourceControlRepository.identity.description,
          location: sourceControlRepository.location
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

extension Manifest {
  func toTargets(
    packageDependencies: [SwiftPackage.Dependency]
  ) -> [SwiftPackage.Target] {
    targets.map { target in
      .init(
        name: target.name,
        dependencies: target.dependencies.compactMap { dependency in
          switch dependency {
          case .byName(let name, _):
            guard
              let dependency = packageDependencies.first(where: { $0.name == name }),
              case .local(let local) = dependency
            else {
              guard targets.first(where: { $0.name == name }) != .none else {
                return .none
              }
              return .module(
                .init(name: name)
              )
            }
            return .local(
              .init(location: local.location)
            )
          case .product(let name, let package, _):
            guard
              let dependency = packageDependencies.first(where: { $0.name == package }),
              case .remote(let remote) = dependency
            else {
              return .none
            }
            return .remote(
              .init(
                gitName: package ?? name,
                targetName: name,
                location: remote.location
              )
            )
          case .target(_, _):
            // TODO: Handle target dependencies
            return .none
          }
        }
      )
    }
  }
}
