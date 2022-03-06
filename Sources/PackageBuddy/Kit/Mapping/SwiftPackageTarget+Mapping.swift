//
//  SwiftPackageTarget.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PackageModel

extension SwiftPackage.Target.Dependency {
  enum MappingError: Error {
    case targetDependencyMissingInPackageDependencies(name: String)
    case targetDependencyMissingLocally(name: String)
    case targetDependencyTypeTargetNotImplemented
  }
}

extension SwiftPackage.Target {
  static func build(
    from manifest: Manifest,
    target: TargetDescription,
    using dependencies: [SwiftPackage.Dependency]
  ) throws -> Self {
    .init(
      name: target.name,
      type: .build(from: target.type),
      dependencies: try target.dependencies.compactMap { dependency in
        try .build(from: manifest, targetDependency: dependency, using: dependencies)
      }
    )
  }
}

extension SwiftPackage.TargetType {
  static func build(from targetType: TargetDescription.TargetType) -> Self {
    switch targetType {
    case .regular:
      return .regular
    case .executable:
      return .executable
    case .test:
      return .test
    case .system, .binary, .plugin:
      return .other
    }
  }
}

extension SwiftPackage.Target.Dependency {
  static func build(
    from manifest: Manifest,
    targetDependency: TargetDescription.Dependency,
    using packageDependencies: [SwiftPackage.Dependency]
  ) throws -> Self {
    switch targetDependency {
    case .byName(let name, _):
      return try buildDependencyByName(
        name,
        from: manifest,
        targetDependency: targetDependency,
        using: packageDependencies
      )
    case .product(let name, let package, _, _):
      return try buildProductDependency(
        name: name,
        package: package,
        from: manifest,
        targetDependency: targetDependency,
        using: packageDependencies
      )
    case .target(_, _):
      throw MappingError.targetDependencyTypeTargetNotImplemented
    }
  }

  private static func buildDependencyByName(
    _ name: String,
    from manifest: Manifest,
    targetDependency: TargetDescription.Dependency,
    using packageDependencies: [SwiftPackage.Dependency]
  ) throws -> Self {
    guard let dependency = packageDependencies.findLocal(byName: name) else {
      if manifest.targets.first(where: { $0.name == name }) != .none {
        return .module(.init(name: name))
      }
      throw MappingError.targetDependencyMissingInPackageDependencies(name: name)
    }
    guard case .local(let local) = dependency else {
      // NOTE: Should never happen, because findLocal retrieves only local packages.
      throw MappingError.targetDependencyMissingLocally(name: name)
    }
    return .local(fileLocation: local.location)
  }

  private static func buildProductDependency(
    name: String,
    package: String?,
    from manifest: Manifest,
    targetDependency: TargetDescription.Dependency,
    using packageDependencies: [SwiftPackage.Dependency]
  ) throws -> Self {
    let dependency: SwiftPackage.Dependency = try {
      if let matchingRemoteName = packageDependencies.findRemote(byResolutionName: name) {
        return matchingRemoteName
      } else if let package = package {
        if let matchingRemotePackage = packageDependencies.findRemote(byResolutionName: package) {
          return matchingRemotePackage
        } else if let matchingLocalPackage = packageDependencies.findLocal(byName: package) {
          return matchingLocalPackage
        }
      }
      throw MappingError.targetDependencyMissingInPackageDependencies(name: name)
    }()
    switch dependency {
    case .local:
      return .module(.init(name: name))
    case .remote(let remote):
      return .remote(
        .init(
          gitName: remote.gitName,
          targetName: name,
          location: remote.location
        )
      )
    }
  }
}
