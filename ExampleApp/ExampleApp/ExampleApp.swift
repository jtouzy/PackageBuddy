//
//  ExampleApp.swift
//  ExampleApp
//
//  Created by Jérémy Touzy on 05/12/2021.
//

import ModuleA
import SwiftUI

@main
struct ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ModuleA()
      }
    }
  }
}
