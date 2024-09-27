// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GeoLocs",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "GeoLocs",
            type: .dynamic,
            targets: ["GeoLocs"])
    ],
    dependencies: [.package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0")],
    targets: [
        .target(
            name: "GeoLocs",
            path: "./Sources/GeoLocs",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]),
        .testTarget(
            name: "GeoLocsTests",
            dependencies: ["GeoLocs"],
            path: "./Tests/GeoLocsTests")
    ]
)
