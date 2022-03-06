//
//  SwiftPackage.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

// ========================================================================
// MARK: SwiftPackage Requirement definition
// ========================================================================

extension SwiftPackage {
  public enum Requirement: Codable {
    case exact(version: String)
    case unknown
  }
}

// ========================================================================
// MARK: SwiftPackage Requirement computed properties
// ========================================================================

extension SwiftPackage.Requirement {
  public var readableVersion: String {
    switch self {
    case .exact(let version):
      return version
    case .unknown:
      return "unknown"
    }
  }
}
