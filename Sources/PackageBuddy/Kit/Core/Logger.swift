//
//  Logger.swift
//  PackageBuddy
//
//  Copyright © 2022 Jérémy TOUZY and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation
import Rainbow

// ========================================================================
// MARK: Logger
// All about output logging is right there.
// ========================================================================

struct Logger {
}

extension Logger {
  static let main: Logger.Main = .init()

  static func make(_ moduleName: String) -> Logger.Module {
    .init(moduleName: moduleName)
  }
}

extension Logger {
  struct Main {
    func welcome() {
      print("\n 📦 \("PackageBuddy".bold): Your best SPM buddy.\n")
    }
    func goodbye() {
      print("")
    }
  }
}

extension Logger {
  struct Module {
    private let moduleName: String

    fileprivate init(moduleName: String) {
      self.moduleName = moduleName
    }

    func print(_ message: String) {
      Swift.print(" · \(moduleName.bold.cyan): \(message)")
    }
  }
}
