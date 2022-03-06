//
//  ProjectDescriptorKit.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import PathKit

// ========================================================================
// MARK: ProjectDescriptorKit
// All tools related to a project description.
// ========================================================================

struct ProjectDescriptorKit {
  typealias EvaluateProjectDescriptor = (Path, Bool) throws -> [SwiftPackage]

  let evaluateProjectDescriptor: EvaluateProjectDescriptor

  private init(
    evaluateProjectDescriptor: @escaping EvaluateProjectDescriptor
  ) {
    self.evaluateProjectDescriptor = evaluateProjectDescriptor
  }
}

// ========================================================================
// MARK: Live implementation
// ========================================================================

extension ProjectDescriptorKit {
  enum Live {
    typealias AnalyzeProjectDescriptor = (Path) throws -> [SwiftPackage]
    static let fileName = "PackageBuddy.json"
    static let logger = Logger.make("ProjectDescriptor")
  }

  static var live: Self {
    createLive(
      analyzeProjectPath: PackageAnalyzingKit.live.analyzeProjectPath
    )
  }

  static func createLive(
    analyzeProjectPath: @escaping Live.AnalyzeProjectDescriptor
  ) -> Self {
    .init(
      evaluateProjectDescriptor: evaluateProjectDescriptorLive(
        analyzeProjectPath: analyzeProjectPath
      )
    )
  }
}

private func evaluateProjectDescriptorLive(
  analyzeProjectPath: @escaping ProjectDescriptorKit.Live.AnalyzeProjectDescriptor
) -> ProjectDescriptorKit.EvaluateProjectDescriptor {
  return { projectPath, requiresAnalysis in
    let descriptorCacheFileName = ProjectDescriptorKit.Live.fileName
    let descriptorCacheFilePath = projectPath + Path(descriptorCacheFileName)
    if descriptorCacheFilePath.exists && requiresAnalysis == false {
      printLaunchingFromCache(descriptorCacheFileName)
      let cacheFileData = try descriptorCacheFilePath.read()
      let jsonDecoder = JSONDecoder()
      return try jsonDecoder.decode([SwiftPackage].self, from: cacheFileData)
    }
    printAnalyzingDirectory(descriptorCacheFileName)
    let descriptor = try analyzeProjectPath(projectPath)
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let descriptorData = try jsonEncoder.encode(descriptor)
    try descriptorCacheFilePath.write(descriptorData)
    return descriptor
  }
}

private func printLaunchingFromCache(_ descriptorCacheFileName: String) {
  ProjectDescriptorKit.Live.logger.print(
    "\(descriptorCacheFileName.bold) found in directory. Launching from cache."
  )
}
private func printAnalyzingDirectory(_ descriptorCacheFileName: String) {
  ProjectDescriptorKit.Live.logger.print(
    "No \(descriptorCacheFileName.bold) found in directory. \("Analyzing directory".bold)."
  )
}
