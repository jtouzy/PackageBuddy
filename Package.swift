// swift-tools-version: 5.5

import PackageDescription

let package = Package(
  name: "PackageBuddy",
  platforms: [
    .macOS("10.15.4")
  ],
  products: [
    .executable(
      name: "pbuddy",
      targets: ["PackageBuddy"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/kylef/PathKit",
      .exact("1.0.1")
    ),
    .package(
      url: "https://github.com/onevcat/Rainbow",
      .exact("4.0.1")
    ),
    .package(
      url: "https://github.com/apple/swift-argument-parser",
      .exact("1.0.3")
    ),
    .package(
      url: "https://github.com/apple/swift-package-manager",
      .revision("d03213a6e2d60bd2eaad0ffee59bef8909bbcf82")
    )
  ],
  targets: [
    .executableTarget(
      name: "PackageBuddy",
      dependencies: [
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser"
        ),
        .product(
          name: "PathKit",
          package: "PathKit"
        ),
        .product(
          name: "Rainbow",
          package: "Rainbow"
        ),
        .product(
          name: "SwiftPM",
          package: "swift-package-manager"
        )
      ]
    )
  ]
)
