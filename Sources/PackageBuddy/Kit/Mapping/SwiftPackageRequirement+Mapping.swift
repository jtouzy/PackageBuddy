//
//  SwiftPackageRequirement+Mapping.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PackageModel

extension SwiftPackage.Requirement {
  static func build(from requirement: PackageDependency.SourceControl.Requirement) -> Self {
    switch requirement {
    case .branch:
      ()
    case .exact(let version):
      return .exact(version: version.description)
    case .range:
      ()
    case .revision:
      ()
    }
    return .unknown
  }
}
