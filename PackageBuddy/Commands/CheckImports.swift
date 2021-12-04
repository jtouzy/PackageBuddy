//
//  CheckImports.swift
//  CheckImports
//
//  Created by Jérémy Touzy on 07/09/2021.
//

import ArgumentParser
import PathKit
import Foundation

struct CheckImports: ParsableCommand {
  @Option(
    name: [.customShort("p"), .customLong("project-path")]
  )
  var projectPathString: String
}

extension CheckImports {
  private static let defaultExcludedImports: [String] = [
    "AdServices",
    "AdSupport",
    "AppTrackingTransparency",
    "Cocoa",
    "Combine",
    "CommonCrypto",
    "CoreGraphics",
    "CoreLocation",
    "CoreImage",
    "Darwin",
    "Foundation",
    "iAd",
    "MapKit",
    "OSLog",
    "NotificationCenter",
    "Photos",
    "StoreKit",
    "SwiftUI",
    "UIKit",
    "UserNotifications",
    "WebKit",
    "XCTest"
  ]
}

extension CheckImports {
  func run() throws {
    let runner = Runner(
      projectDescriptorKit: .live,
      sourceAnalyzingKit: .live,
      projectPath: Path(projectPathString)
    )
    try runner.run()
  }
}

// ========================================================================
// MARK: CheckImports: Runner
// ========================================================================

private extension CheckImports {
  struct Runner {
    let projectDescriptorKit: ProjectDescriptorKit
    let sourceAnalyzingKit: SourceAnalyzingKit
    let projectPath: Path
  }
}

extension CheckImports.Runner {
  fileprivate static let logger = Logger.make("CheckImports")

  func run() throws {
    let projectDescriptor = try projectDescriptorKit.evaluateProjectDescriptor(projectPath, false)

    for package in projectDescriptor {
      for product in package.products {
        for target in product.targets {
          // NOTE: For checking dependencies, we take only this target dependencies.
          let toCheckTargetDependencyNames = target.dependencies.map { $0.name }
          let targetSourcePath = Path(package.location.pathString) + Path("Sources") + Path(target.name)
          let uniqueSourceImports = try sourceAnalyzingKit.findSourceImports(targetSourcePath)
          let sortedSourceImports: [String] = {
            Array(uniqueSourceImports).filter {
              CheckImports.defaultExcludedImports.contains($0) == false
            }
          }()
          var dependenciesWithoutImports: [String] = []
          toCheckTargetDependencyNames.forEach { dependency in
            if sortedSourceImports.contains(dependency) == false {
              dependenciesWithoutImports.append(dependency)
            }
          }
          var importsWithoutDependencies: [String] = []
          sortedSourceImports.forEach { sourceImport in
            if toCheckTargetDependencyNames.contains(sourceImport) == false {
              importsWithoutDependencies.append(sourceImport)
            }
          }
          if dependenciesWithoutImports.isEmpty == false || importsWithoutDependencies.isEmpty == false {
            printTargetHeaderWithWarning(
              packageName: package.name,
              targetName: target.name
            )
            if dependenciesWithoutImports.isEmpty == false {
              printDependenciesWithoutImports(dependenciesWithoutImports)
            }
            if importsWithoutDependencies.isEmpty == false {
              printImportsWithoutDependencies(importsWithoutDependencies)
            }
          } else {
            printTargetHeaderSuccess(
              packageName: package.name,
              targetName: target.name
            )
          }
        }
      }
    }
  }
}

private func printTargetHeaderSuccess(packageName: String, targetName: String) {
  let header = buildHeader(from: packageName, targetName: targetName)
  CheckImports.Runner.logger.print("\("✓ \(header)".green)")
}
private func printTargetHeaderWithWarning(packageName: String, targetName: String) {
  let header = buildHeader(from: packageName, targetName: targetName)
  CheckImports.Runner.logger.print("\("! \(header)".white.onRed.bold)")
}
private func buildHeader(from packageName: String, targetName: String) -> String {
  if packageName != targetName {
    return "\(packageName) [target=\(targetName)]"
  }
  return packageName
}
private func printDependenciesWithoutImports(_ dependenciesWithoutImports: [String]) {
  CheckImports.Runner.logger.print("  → Listed in Package.swift, no imports: \(dependenciesWithoutImports.description.red.italic)".yellow)
}
private func printImportsWithoutDependencies(_ importsWithoutDependencies: [String]) {
  CheckImports.Runner.logger.print("  → Imported but missing in Package.swift: \(importsWithoutDependencies.description.red.italic)".yellow)
}
