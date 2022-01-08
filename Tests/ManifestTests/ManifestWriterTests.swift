import Foundation
import ManifestDescription
import ManifestWriting
import XCTest

class ManifestWriterTests: XCTestCase {
    func testWrite() throws {
        let manifest = Manifest(
            toolsVersion: .v5_5,
            package: Package(
                name: "MyPackage",
                platforms: [
                    .init(name: "iOS", oldestSupportedVersion: .init(value: "15.2")),
                    .init(name: "macOS", oldestSupportedVersion: .init(value: "12"))
                ],
                products: [
                    Product(
                        name: "AppModule",
                        type: .iOSApplication,
                        targets: ["AppModule"],
                        settings: [
                            .bundleIdentifier("com.abc.def"),
//                            .teamIdentifier("123"),
                            .bundleVersion("1"),
                            .displayVersion("1.0"),
                            .iOSAppInfo(ProductSetting.IOSAppInfo(
                                iconAssetName: "AppIcon",
                                accentColorAssetName: nil,
                                supportedDeviceFamilies: [.pad, .mac, .phone],
                                supportedInterfaceOrientations: [
                                    .portrait,
                                    .landscapeRight(),
                                    .landscapeLeft,
                                    .portraitUpsideDown(.when(deviceFamilies: [.pad]))
                                ],
                                capabilities: [
                                    .camera(purposeString: "Take a picture", .when(deviceFamilies: [.pad])),
                                    .bluetoothAlways(purposeString: "Find local devices"),
                                    .localNetwork(purposeString: "Find local devices", bonjourServiceTypes: ["A"]),
                                    .appTransportSecurity(
                                        configuration: .init(
                                            allowsArbitraryLoadsInWebContent: true,
                                            allowsArbitraryLoadsForMedia: false,
                                            allowsLocalNetworking: nil,
                                            exceptionDomains: [
                                                .init(
                                                    domainName: "foo.com",
                                                    includesSubdomains: false,
                                                    exceptionAllowsInsecureHTTPLoads: true,
                                                    exceptionMinimumTLSVersion: nil,
                                                    exceptionRequiresForwardSecrecy: nil,
                                                    requiresCertificateTransparency: nil
                                                )
                                            ],
                                            pinnedDomains: [
                                                .init(
                                                    domainName: "bar.baz",
                                                    includesSubdomains: nil,
                                                    pinnedCAIdentities: [
                                                        ["foo.com": "bar"]
                                                    ],
                                                    pinnedLeafIdentities: nil
                                                )
                                            ]
                                        )
                                    )
                                ],
                                additionalInfoPlistContentFilePath: nil
                            ))
                        ]
                    ),
                    Product(
                        name: "Support",
                        type: .library,
                        targets: ["Support"],
                        settings: []
                    ),
                    Product(
                        name: "CLI",
                        type: .executable,
                        targets: ["CLI"],
                        settings: []
                    )
                ],
                dependencies: [
                    .sourceControl(
                        name: nil,
                        url: URL(string: "https://github.com/alamofire/alamofire")!,
                        requirement: .range("0.2.0" ..< "1.0.0")
                    ),
                    .sourceControl(
                        name: "Foo",
                        url: URL(string: "https://github.com/foo/foo")!,
                        requirement: .exact("1.2.4")
                    ),
                    .fileSystem(name: nil, path: "../swift-argument-parser")
                ],
                targets: [
                    Target(
                        name: "AppModule",
                        type: .executable,
                        dependencies: [
                            .byName(name: "literal"),
                            .product(name: "Alamofire", package: "alamofire"),
                        ],
                        path: nil
                    )
                ]
            )
        )

        let writer = ManifestWriter()
        writer.options.prettyPrint = false
        
        let result = try writer.write(manifest)

        XCTAssertEqual(result, """
        // swift-tools-version: 5.5

        // Generated using https://github.com/liamnichols/SwiftPackageManifest

        import PackageDescription
        import AppleProductTypes

        let package = Package(name: "MyPackage", platforms: [.iOS("15.2"), .macOS("12")], products: [.iOSApplication(name: "AppModule", targets: ["AppModule"], bundleIdentifier: "com.abc.def", displayVersion: "1.0", bundleVersion: "1", iconAssetName: "AppIcon", supportedDeviceFamilies: [.pad, .mac, .phone], supportedInterfaceOrientations: [.portrait, .landscapeRight, .landscapeLeft, .portraitUpsideDown(.when(deviceFamilies: [.pad]))], capabilities: [.camera(purposeString: "Take a picture", .when(deviceFamilies: [.pad])), .bluetoothAlways(purposeString: "Find local devices"), .localNetwork(purposeString: "Find local devices", bonjourServiceTypes: ["A"]), .appTransportSecurity(configuration: .init(allowsArbitraryLoadsInWebContent: true, allowsArbitraryLoadsForMedia: false, exceptionDomains: [.init(domainName: "foo.com", includesSubdomains: false, exceptionAllowsInsecureHTTPLoads: true)], pinnedDomains: [.init(domainName: "bar.baz", pinnedCAIdentities: [["foo.com": "bar"]])]))]), .library(name: "Support", targets: ["Support"]), .executable(name: "CLI", targets: ["CLI"])], dependencies: [.package(url: "https://github.com/alamofire/alamofire", "0.2.0"..<"1.0.0"), .package(name: "Foo", url: "https://github.com/foo/foo", .exact("1.2.4")), .package(path: "../swift-argument-parser")], targets: [.executableTarget(name: "AppModule", dependencies: ["literal", .product(name: "Alamofire", package: "alamofire")])])
        """)
    }
}
