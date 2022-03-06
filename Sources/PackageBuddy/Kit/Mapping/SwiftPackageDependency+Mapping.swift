//
//  SwiftPackageDependency.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PackageModel
import PathKit

extension SwiftPackage.Dependency {
  enum MappingError: Error {
    case registryPackageDependencyNotImplemented
  }
}

extension SwiftPackage.Dependency {
  static func build(from packageDependency: PackageDependency) throws -> Self {
    switch packageDependency {
    case .fileSystem(let fileSystem):
      return .local(path: Path(fileSystem.path.pathString))
    case .sourceControl(let sourceControl):
      return .remote(
        .init(
          resolutionName: sourceControl.nameForTargetDependencyResolutionOnly,
          gitName: sourceControl.identity.description,
          location: sourceControl.location.stringified,
          requirement: SwiftPackage.Requirement.build(from: sourceControl.requirement)
        )
      )
    case .registry:
      throw MappingError.registryPackageDependencyNotImplemented
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
