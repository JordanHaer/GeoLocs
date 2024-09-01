// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "GeoLocs",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "GeoLocs",
            targets: ["GeoLocs"]),
    ],
    targets: [
        .target(
            name: "GeoLocs",
            path: "./Sources/GeoLocs",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .testTarget(
            name: "GeoLocsTests",
            dependencies: ["GeoLocs"],
            path: "./Tests/GeoLocsTests"),
    ]
)
