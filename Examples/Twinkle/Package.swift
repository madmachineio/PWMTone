// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Twinkle",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/madmachineio/SwiftIO.git", from: "0.0.1"),
        .package(url: "https://github.com/madmachineio/MadBoards.git", from: "0.0.1"),
        .package(url: "https://github.com/madmachineio/MadDrivers.git", from: "0.0.1"),
        .package(path: "../../"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Twinkle",
            dependencies: [
                "SwiftIO",
                "MadBoards",
                "MadDrivers",
                "PWMTone"]),
        .testTarget(
            name: "TwinkleTests",
            dependencies: ["Twinkle"]),
    ]
)
