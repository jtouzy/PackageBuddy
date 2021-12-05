// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "ModuleA",
  platforms: [
    .iOS(.v14),
    .macOS(.v11)
  ],
  products: [
    .library(
      name: "ModuleA",
      targets: [
        "ModuleA"
      ]
    )
  ],
  dependencies: [
    .package(path: "../ModuleB")
  ],
  targets: [
    .target(
      name: "ModuleA",
      dependencies: [
        "ModuleB"
      ]
    ),
    .testTarget(
      name: "ModuleATests",
      dependencies: [
        "ModuleA"
      ]
    )
  ]
)
