// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "ButterBot",
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "3.0.0")),
    .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc.2.3"),
    .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2.2")
  ],
  targets: [
    .target(name: "App", dependencies: ["FluentPostgreSQL", "Leaf", "Vapor"]),
    .target(name: "Run", dependencies: ["App"]),
    .testTarget(name: "AppTests", dependencies: ["App"])
  ]
)
