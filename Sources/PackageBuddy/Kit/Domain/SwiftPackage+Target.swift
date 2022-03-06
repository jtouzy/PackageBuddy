//
//  SwiftPackage+Target.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

// ========================================================================
// MARK: SwiftPackage Target definition
// ========================================================================

extension SwiftPackage {
  public struct Target: Codable {
    public let name: String
    public let type: TargetType
    public let dependencies: [Dependency]
  }
}

// ========================================================================
// MARK: SwiftPackage Target Type definition
// ========================================================================

extension SwiftPackage {
  public enum TargetType: Codable {
    case executable
    case other
    case regular
    case test
  }
}

// ========================================================================
// MARK: SwiftPackage Target Dependency definition
// ========================================================================

extension SwiftPackage.Target {
  public enum Dependency: Codable {
    case local(Local)
    case module(Module)
    case remote(Remote)
  }
}
extension SwiftPackage.Target.Dependency {
  public struct Local: Codable {
    public let location: FileLocation
  }
  public struct Module: Codable {
    public let name: String
  }
  public struct Remote: Codable {
    public let gitName: String
    public let targetName: String
    public let location: String
  }
}

// ========================================================================
// MARK: SwiftPackage Target Dependency builders
// ========================================================================

extension SwiftPackage.Target.Dependency {
  public static func local(fileLocation: FileLocation) -> Self {
    .local(.init(location: fileLocation))
  }
}

// ========================================================================
// MARK: SwiftPackage Target Dependency computed properties
// ========================================================================

extension SwiftPackage.Target.Dependency {
  public var displayName: String {
    switch self {
    case .local(let local):
      return local.location.name
    case .module(let module):
      return module.name
    case .remote(let remote):
      return remote.gitName
    }
  }
}
