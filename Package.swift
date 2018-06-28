// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "ButterBot",
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git",  .exact("3.0.5")),
    .package(url: "https://github.com/vapor/fluent-postgresql.git", .exact("1.0.0-rc.4.0.2")),
    .package(url: "https://github.com/vapor/leaf.git", .exact("3.0.0-rc.2.2")),
    .package(url:"https://github.com/crossroadlabs/Regex", .exact("1.1.0"))
  ],
  targets: [
    .target(name: "App", dependencies: ["FluentPostgreSQL", "Leaf", "Vapor", "Regex"]),
    .target(name: "Run", dependencies: ["App"]),
    .testTarget(name: "AppTests", dependencies: ["App"])
  ]
)
