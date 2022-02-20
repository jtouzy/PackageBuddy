//
//  SwiftPM+Mapping.swift
//  PackageBuddy
//
//  Created by Jérémy Touzy on 10/07/2021.
//

import PackageModel
import PathKit

extension PackageDependency {
  var toDependency: SwiftPackage.Dependency? {
    switch self {
    case .fileSystem(let fileSystem):
      return .local(
        path: Path(fileSystem.path.pathString)
      )
    case .sourceControl(let sourceControl):
      return .remote(
        .init(
          name: sourceControl.nameForTargetDependencyResolutionOnly ?? sourceControl.identity.description,
          location: sourceControl.location.stringified
        )
      )
    case .registry:
      return .none
    }
  }
}

extension PackageDependency.SourceControl.Location {
  var stringified: String {
    switch self {
    case .local(let path):
      return path.pathString
    case .remote(let url):
      return url.absoluteString
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
          case .product(let name, let package, _, _):
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
