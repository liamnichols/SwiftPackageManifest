import Foundation
import ManifestDescription
import SwiftSyntax

extension Product: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Make sure this function all looks roughly like we expect it to.
        let memberAccess = try functionCall.memberAccess(context)

        // Read the arguments to form the Product
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            switch memberAccess.name.text {
            case "library":
                return Product(
                    name: try processor.take("name", as: String.self),
                    type: .library,
                    targets: try processor.take("targets", as: [String].self),
                    settings: []
                )

            case "executable":
                return Product(
                    name: try processor.take("name", as: String.self),
                    type: .executable,
                    targets: try processor.take("targets", as: [String].self),
                    settings: []
                )

            case "iOSApplication":
                return Product(
                    name: try processor.take("name", as: String.self),
                    type: .iOSApplication,
                    targets: try processor.take("targets", as: [String].self),
                    settings: try Self.iOSApplicationSettings(from: processor)
                )

            case let other:
                throw context.error("Unupported product type '\(other)'")
            }
        }
    }

    private static func iOSApplicationSettings(from processor: SyntaxArgumentProcessor) throws -> [ProductSetting] {
        typealias DeviceFamily = ProductSetting.IOSAppInfo.DeviceFamily
        typealias InterfaceOrientation = ProductSetting.IOSAppInfo.InterfaceOrientation
        typealias Capability = ProductSetting.IOSAppInfo.Capability

        var settings: [ProductSetting] = []

        if let bundleIdentifier = try processor.takeIfDefined("bundleIdentifier", as: String?.self) ?? nil {
            settings.append(.bundleIdentifier(bundleIdentifier))
        }

        if let teamIdentifier = try processor.takeIfDefined("teamIdentifier", as: String?.self) ?? nil {
            settings.append(.teamIdentifier(teamIdentifier))
        }

        if let displayVersion = try processor.takeIfDefined("displayVersion", as: String?.self) ?? nil {
            settings.append(.displayVersion(displayVersion))
        }

        if let bundleVersion = try processor.takeIfDefined("bundleVersion", as: String?.self) ?? nil {
            settings.append(.bundleVersion(bundleVersion))
        }

        settings.append(
            .iOSAppInfo(
                ProductSetting.IOSAppInfo(
                    iconAssetName: try processor.takeIfDefined("iconAssetName", as: String?.self) ?? nil,
                    accentColorAssetName: try processor.takeIfDefined("accentColorAssetName", as: String?.self) ?? nil,
                    supportedDeviceFamilies: try processor.take("supportedDeviceFamilies", as: [DeviceFamily].self),
                    supportedInterfaceOrientations: try processor
                        .take("supportedInterfaceOrientations", as: [InterfaceOrientation].self),
                    capabilities: try processor.takeIfDefined("capabilities", as: [Capability].self) ?? [],
                    additionalInfoPlistContentFilePath: try processor
                        .takeIfDefined("additionalInfoPlistContentFilePath", as: String?.self) ?? nil
                )
            )
        )

        return settings
    }
}
