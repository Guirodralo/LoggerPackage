// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggerPackage",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LoggerPackage",
            targets: ["LoggerManager"])
    ],
    dependencies: [
        // Internal
        .package(
            name: "EnvironmentPackage",
            path: "../Environment"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LoggerManager",
            dependencies: [
                .product(
                    name: "EnvironmentLibrary",
                    package: "EnvironmentPackage"
                )
            ]
        )
    ]
)
