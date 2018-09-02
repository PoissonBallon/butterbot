// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "ButterBot",
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git",             .upToNextMinor(from: "3.0.8")),
    .package(url: "https://github.com/vapor/fluent-postgresql.git", .upToNextMinor(from: "1.0.0")),
    .package(url: "https://github.com/vapor/leaf.git",              .upToNextMinor(from: "3.0.1")),
    .package(url: "https://github.com/crossroadlabs/Regex",         .upToNextMinor(from: "1.1.0")),
    .package(url: "https://github.com/PoissonBallon/google-analytics-provider.git", from: "0.0.2")
  ],
  targets: [
    .target(name: "App", dependencies: ["FluentPostgreSQL", "Leaf", "Vapor", "Regex", "GoogleAnalyticsProvider"]),
    .target(name: "Run", dependencies: ["App"]),
    .testTarget(name: "AppTests", dependencies: ["App"])
  ]
)
