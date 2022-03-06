//
//  SwiftPackage+Product.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

// ========================================================================
// MARK: SwiftPackage Product definition
// ========================================================================

extension SwiftPackage {
  public struct Product: Codable {
    public let name: String
    public let targets: [Target]
  }
}
