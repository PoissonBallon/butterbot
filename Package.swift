// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "butterbot-app",
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git",             .upToNextMinor(from: "3.1.0")),
    .package(url: "https://github.com/vapor/fluent-postgresql.git", .upToNextMinor(from: "1.0.0")),
    .package(url: "https://github.com/vapor/leaf.git",              .upToNextMinor(from: "3.0.1")),
    .package(url: "https://github.com/crossroadlabs/Regex",         .upToNextMinor(from: "1.1.0")),
    .package(url: "https://github.com/PoissonBallon/google-analytics-provider.git", from: "0.0.2"),
    .package(url: "https://github.com/pvzig/SlackKit.git",          .upToNextMinor(from: "4.3.0"))
  ],
  targets: [
    .target(name: "Run", dependencies: ["Butterbot"]),
    
    .target(name: "Butterbot", dependencies:["Leaf", "Vapor", "Regex", "FluentPostgreSQL", "SKCore"]),
    .target(name: "ButterFeatureAskme", dependencies: ["Butterbot", "Vapor", "FluentPostgreSQL"]),
    .target(name: "ButterFeatureKarma", dependencies: ["Butterbot"])
  ]
)
