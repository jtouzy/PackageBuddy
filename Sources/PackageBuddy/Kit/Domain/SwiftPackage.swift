//
//  SwiftPackage.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import PathKit

// ========================================================================
// MARK: SwiftPackage definition
// ========================================================================

public struct SwiftPackage: Codable {
  public var name: String { location.name }
  public let location: FileLocation
  public let dependencies: [Dependency]
  public let products: [Product]
}

// ========================================================================
// MARK: SwiftPackage computed properties
// ========================================================================

extension SwiftPackage {
  public var mainProduct: Product? {
    products.first(where: { $0.name == name })
  }
}

// ========================================================================
// MARK: Array extensions for SwiftPackage Dependencies
// ========================================================================

extension Array where Element == SwiftPackage {
  func findLocal(fromTargetDependency targetDependency: SwiftPackage.Target.Dependency) -> Element? {
    guard case .local(let local) = targetDependency else {
      return .none
    }
    return first(where: { $0.name == local.location.name })
  }
}
