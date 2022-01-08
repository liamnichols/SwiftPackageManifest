import Foundation
import ManifestDescription
import SwiftSyntax

private extension Product.ProductType {
    var memberAccessName: Identifier {
        switch self {
        case .executable:
            return "executable"
        case .library:
            return "library"
        case .iOSApplication:
            return "iOSApplication"
        }
    }
}

extension Product: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: type.memberAccessName)
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = [
            FunctionCallArgument(
                label: "name",
                expression: StringLiteral(content: name)
            ),
            FunctionCallArgument(
                label: "targets",
                expression: ArrayLiteral(content: targets.map({ StringLiteral(content: $0) }))
            )
        ]

        if type == .iOSApplication {
            arguments.append(contentsOf: iOSApplicationArguments(from: settings))
        }

        return arguments
    }

    func iOSApplicationArguments(from settings: [ProductSetting]) -> [FunctionCallArgument] {
        // First, we must read the settings that are relevant to us
        var bundleIdentifier: String?, teamIdentifier: String?, displayVersion: String?, bundleVersion: String?
        var iOSAppInfo: ProductSetting.IOSAppInfo?

        for setting in settings {
            switch setting {
            case .bundleIdentifier(let string):
                bundleIdentifier = string
            case .teamIdentifier(let string):
                teamIdentifier = string
            case .displayVersion(let string):
                displayVersion = string
            case .bundleVersion(let string):
                bundleVersion = string
            case .iOSAppInfo(let value):
                iOSAppInfo = value
            }
        }

        // Ensure that the iOSAppInfo is present
        guard let iOSAppInfo = iOSAppInfo else {
            // TODO: Ability to throw errors up
            // The iOSAppInfo must be provided for an iOSApplication product.
            fatalError("iOSAppInfo product setting is required for iOSApplication products but it is missing")
        }

        // Collect the arguments that have been defined
        var arguments: [FunctionCallArgument] = []

        if let bundleIdentifier = bundleIdentifier {
            arguments.append(FunctionCallArgument(
                label: "bundleIdentifier",
                expression: StringLiteral(content: bundleIdentifier)
            ))
        }

        if let teamIdentifier = teamIdentifier {
            arguments.append(FunctionCallArgument(
                label: "teamIdentifier",
                expression: StringLiteral(content: teamIdentifier)
            ))
        }

        if let displayVersion = displayVersion {
            arguments.append(FunctionCallArgument(
                label: "displayVersion",
                expression: StringLiteral(content: displayVersion)
            ))
        }

        if let bundleVersion = bundleVersion {
            arguments.append(FunctionCallArgument(
                label: "bundleVersion",
                expression: StringLiteral(content: bundleVersion)
            ))
        }

        if let iconAssetName = iOSAppInfo.iconAssetName {
            arguments.append(FunctionCallArgument(
                label: "iconAssetName",
                expression: StringLiteral(content: iconAssetName)
            ))
        }

        if let accentColorAssetName = iOSAppInfo.accentColorAssetName {
            arguments.append(FunctionCallArgument(
                label: "accentColorAssetName",
                expression: StringLiteral(content: accentColorAssetName)
            ))
        }

        // TODO: Support
        arguments.append(FunctionCallArgument(
            label: "supportedDeviceFamilies",
            expression: ArrayLiteral(content: iOSAppInfo.supportedDeviceFamilies)
        ))

        // TODO: Support
        arguments.append(FunctionCallArgument(
            label: "supportedInterfaceOrientations",
            expression: ArrayLiteral(content: iOSAppInfo.supportedInterfaceOrientations)
        ))

        // TODO: Support
        if !iOSAppInfo.capabilities.isEmpty {
            arguments.append(FunctionCallArgument(
                label: "capabilities",
                expression: ArrayLiteral(content: iOSAppInfo.capabilities)
            ))
        }

        if let additionalInfoPlistContentFilePath = iOSAppInfo.additionalInfoPlistContentFilePath {
            arguments.append(FunctionCallArgument(
                label: "additionalInfoPlistContentFilePath",
                expression: StringLiteral(content: additionalInfoPlistContentFilePath))
            )
        }

        return arguments
    }
}

