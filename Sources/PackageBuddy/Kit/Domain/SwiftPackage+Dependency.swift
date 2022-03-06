//
//  SwiftPackage+Dependency.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PathKit

// ========================================================================
// MARK: SwiftPackage Dependency definition
// ========================================================================

extension SwiftPackage {
  public enum Dependency: Codable {
    case local(Local)
    case remote(Remote)
  }
}

extension SwiftPackage.Dependency {
  public struct Local: Codable {
    public let location: FileLocation
  }
  public struct Remote: Codable {
    public let resolutionName: String?
    public let gitName: String
    public let location: String
    public let requirement: SwiftPackage.Requirement
  }
}

// ========================================================================
// MARK: SwiftPackage Dependency computed properties
// ========================================================================

extension SwiftPackage.Dependency {
  public var displayName: String {
    switch self {
    case .local(let local):
      return local.location.name
    case .remote(let remote):
      return remote.gitName
    }
  }
  public var requirement: SwiftPackage.Requirement? {
    switch self {
    case .local:
      return .none
    case .remote(let remote):
      return remote.requirement
    }
  }
}
extension SwiftPackage.Dependency.Remote {
  public var searchResolutionName: String {
    resolutionName ?? gitName
  }
}

// ========================================================================
// MARK: SwiftPackage Dependency builders
// ========================================================================

extension SwiftPackage.Dependency {
  public static func local(path: Path) -> Self {
    .local(.init(location: .init(path: path)))
  }
}

// ========================================================================
// MARK: Array extensions for SwiftPackage Dependencies
// ========================================================================

extension Array where Element == SwiftPackage.Dependency {
  func find(fromTargetDependency targetDependency: SwiftPackage.Target.Dependency) -> Element? {
    switch targetDependency {
    case .local(let local):
      return findLocal(byName: local.location.name)
    case .module:
      // NOTE: A module dependency is a inner-package one, it's not related to package dependency.
      return .none
    case .remote(let remote):
      return findRemote(byResolutionName: remote.gitName)
    }
  }
}
extension Array where Element == SwiftPackage.Dependency {
  func findLocal(byName name: String) -> Element? {
    first(where: { element in
      guard case .local(let packageDependencyLocal) = element else {
        return false
      }
      return packageDependencyLocal.location.name == name
    })
  }
  func findRemote(byResolutionName resolutionName: String) -> Element? {
    return first(where: { element in
      guard case .remote(let packageDependencyRemote) = element else {
        return false
      }
      // NOTE: In remote cases, we need to check first for Resolution name. It's an optional
      // name given by SPM, which can be used for package resolutions. If it's not provided,
      // we use gitName.
      return packageDependencyRemote.searchResolutionName.lowercased() == resolutionName.lowercased()
    })
  }
}
