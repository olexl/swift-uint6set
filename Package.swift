// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "uint6set",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "uint6set",
            targets: ["uint6set"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "uint6set"),
        .testTarget(
            name: "uint6setTests",
            dependencies: ["uint6set"]),
    ]
)
