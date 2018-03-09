// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "butterbot",
  dependencies: [
      .package(url: "https://github.com/NoRespect/SlackKit.git", .branch("master")),
      .package(url: "https://github.com/vapor/mysql.git", from: "3.0.0-rc.1.1")
  ],
  targets: [
      .target(name: "butterbot", dependencies: ["SlackKit","MySQL"]),
  ]
)
