//
//  ModuleA.swift
//  ModuleA
//
//  Created by Jérémy Touzy on 05/12/2021.
//

import ModuleB
import SwiftUI

public struct ModuleA: View {
  @State var isNavigationActive: Bool = false

  public var body: some View {
    VStack(spacing: 16.0) {
      Text("Hey, i'm the A-module")
      navigationToModuleB(isActive: $isNavigationActive)
    }
    .navigationTitle("Module A")
  }

  public init() {
  }
}

private func navigationToModuleB(isActive: Binding<Bool>) -> some View {
  NavigationLink(
    isActive: isActive,
    destination: { ModuleB() },
    label: {
      Text("Navigate to Module B")
    }
  )
}
