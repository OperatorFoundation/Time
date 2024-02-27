// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Time",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Time",
            targets: ["Time"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Number", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Text", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Time",
            dependencies: [
                "Datable",
                "Number",
                "Text",
            ]
        ),
        .testTarget(
            name: "TimeTests",
            dependencies: ["Time"]),
    ],
    swiftLanguageVersions: [.v5]
)
