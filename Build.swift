#!/usr/bin/env swift

import Foundation

let fileManager = FileManager.default

try? fileManager.removeItem(atPath: "GeoLocs.xcframework")

enum Platform: String, CaseIterable {

    case iOS = "iOS"
    case iOSSimulator = "iOS Simulator"

    var archivePath: String {
        switch self {
        case .iOS:
            "Release-iphoneos"
        case .iOSSimulator:
            "Release-iphonesimulator"
        }
    }
}

for platform in Platform.allCases {

    let archivePath = platform.archivePath

    run(
        command: "xcodebuild",
        arguments: [
            "archive", "-workspace", ".", "-scheme", "GeoLocs",
            "-destination", "generic/platform=\(platform.rawValue)",
            "-archivePath", archivePath,
            "-derivedDataPath", ".build",
            "SKIP_INSTALL=NO",
            "BUILD_LIBRARY_FOR_DISTRIBUTION=YES"
        ]
    )

    let frameworkPath = "\(archivePath).xcarchive/Products/usr/local/lib/GeoLocs.framework"
    let modulesPath = "\(frameworkPath)/Modules"

    try? fileManager.createDirectory(atPath: modulesPath, withIntermediateDirectories: true, attributes: nil)

    let buildProductsPath = ".build/Build/Intermediates.noindex/ArchiveIntermediates/GeoLocs/BuildProductsPath"
    let releasePath = "\(buildProductsPath)/\(archivePath)"
    let swiftModulePath = "\(releasePath)/GeoLocs.swiftmodule"

    if fileManager.fileExists(atPath: swiftModulePath) {
        try? fileManager.copyItem(atPath: swiftModulePath, toPath: "\(modulesPath)/GeoLocs.swiftmodule")
    } else {
        let moduleMapContent = "module GeoLocs { export * }"
        let moduleMapPath = "\(modulesPath)/module.modulemap"
        try? moduleMapContent.write(toFile: moduleMapPath, atomically: true, encoding: .utf8)
    }

    let resourcesBundlePath = "\(releasePath)/GeoLocs_GeoLocs.bundle"

    if fileManager.fileExists(atPath: resourcesBundlePath) {
        try? fileManager.copyItem(atPath: resourcesBundlePath, toPath: frameworkPath)
    }
}

run(
    command: "xcodebuild",
    arguments: [
        "-create-xcframework",
        "-framework", "Release-iphoneos.xcarchive/Products/usr/local/lib/GeoLocs.framework",
        "-framework", "Release-iphonesimulator.xcarchive/Products/usr/local/lib/GeoLocs.framework",
        "-output", "GeoLocs.xcframework"
    ]
)

let packageVersion = try getPackageVersion()

run(
    command: "xcodebuild",
    arguments: [
        "docbuild",
        "-scheme", "GeoLocs",
        "-destination", "generic/platform=iOS",
        "-derivedDataPath", ".build"
    ]
)

try moveDoccarchive()

run(
    command: "zip",
    arguments: [
        "-r",
        "GeoLocs-\(packageVersion).zip",
        "GeoLocs.xcframework", "README.md", "GeoLocs.doccarchive"
    ]
)

try? fileManager.removeItem(atPath: "Release-iphoneos.xcarchive")
try? fileManager.removeItem(atPath: "Release-iphonesimulator.xcarchive")

try? fileManager.removeItem(atPath: "GeoLocs.xcframework")

try? fileManager.removeItem(atPath: "GeoLocs.doccarchive")

try moveZip()

func run(command: String, arguments: [String] = []) {
    let process = Process()
    process.launchPath = "/usr/bin/\(command)"
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
    if process.terminationStatus != 0 {
        print("Command failed: \(command) \(arguments.joined(separator: " "))")
        exit(1)
    }
}

func getPackageVersion() throws -> String {

    let filePath = "./Sources/GeoLocs/PackageVersion.swift"
    let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
    let components = fileContents.components(separatedBy: " ")

    guard let versionWithQuotes = components.last else {
        return ""
    }

    return versionWithQuotes
        .replacingOccurrences(of: "\"", with: "")
        .replacingOccurrences(of: "\n", with: "")
}

func moveDoccarchive() throws {
    let sourcePath = ".build/Build/Products/Debug-iphoneos/GeoLocs.doccarchive"
    let destinationPath = "./GeoLocs.doccarchive"

    try fileManager.moveItem(atPath: sourcePath, toPath: destinationPath)
}

func moveZip() throws {
    let sourcePath = "./GeoLocs-\(packageVersion).zip"
    let destinationPath = "../GeoLocs-\(packageVersion).zip"

    try fileManager.moveItem(atPath: sourcePath, toPath: destinationPath)
}
