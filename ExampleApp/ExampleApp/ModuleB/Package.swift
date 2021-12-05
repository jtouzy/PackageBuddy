// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "ModuleB",
  platforms: [
    .iOS(.v14),
    .macOS(.v11)
  ],
  products: [
    .library(
      name: "ModuleB",
      targets: [
        "ModuleB"
      ]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "ModuleB",
      dependencies: [
      ]
    ),
    .testTarget(
      name: "ModuleBTests",
      dependencies: [
        "ModuleB"
      ]
    )
  ]
)
