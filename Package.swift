// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "butterbot",
  dependencies: [
    .package(url: "https://github.com/NoRespect/SlackKit.git", .branch("master")),
    .package(url: "https://github.com/novi/mysql-swift.git", from: "0.9.0-beta.2"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMinor(from: "4.1.2")),
    .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMinor(from: "1.5.1"))
  ],
  targets: [
    .target(name: "butterbot", dependencies: ["SlackKit","MySQL", "RxSwift", "SwiftyBeaver"]),
    ]
)
