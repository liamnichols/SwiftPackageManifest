// swift-tools-version:5.5

import PackageDescription

let swiftSyntaxRequirement: Package.Dependency.Requirement = .exact("0.50500.0")
let package = Package(
    name: "SwiftPackageManifest",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "ManifestDescription", targets: ["ManifestDescription"]),
        .library(name: "ManifestLoading", targets: ["ManifestLoading"]),
        .library(name: "ManifestWriting", targets: ["ManifestWriting"])
    ],
    dependencies: [
        .package(
            name: "_InternalSwiftSyntaxParser",
            url: "https://github.com/liamnichols/_InternalSwiftSyntaxParser.git", swiftSyntaxRequirement
        ),
        .package(
            name: "SwiftSyntax",
            url: "https://github.com/apple/swift-syntax.git", swiftSyntaxRequirement
        ),
        .package(
            name: "Difference",
            url: "https://github.com/krzysztofzablocki/Difference.git", .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(name: "ManifestDescription"),

        .target(name: "ManifestLoading", dependencies: [
            "ManifestDescription",
            "SwiftSyntax",
            "_InternalSwiftSyntaxParser"
        ]),
        .testTarget(name: "ManifestLoadingTests", dependencies: [
            "ManifestLoading",
            "Difference"
        ]),

        .target(name: "ManifestWriting", dependencies: [
            "ManifestDescription",
            "SwiftSyntax",
            "_InternalSwiftSyntaxParser"
        ]),
        .testTarget(name: "ManifestWritingTests", dependencies: [
            "ManifestWriting",
            "Difference"
        ]),
    ]
)
