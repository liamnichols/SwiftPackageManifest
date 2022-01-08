import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.Capability: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    private typealias DeviceFamilyCondition = ProductSetting.IOSAppInfo.DeviceFamilyCondition
    private typealias AppTransportSecurityConfiguration = ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration

    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        let memberAccess = try functionCall.memberAccess(context)
        let member = try Label(memberAccess: memberAccess, context: context)

        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            // Every member has an optional (unlabelled) condition, first parse that
            let deviceFamilyCondition = try processor.takeIfDefined(nil, as: DeviceFamilyCondition?.self) ?? nil

            // appTransportSecurity is a special case because it doesn't have purposeString.
            // NOTE: If more cases are introduced without purposeString, refactor this.
            if case .appTransportSecurity = member {
                return .appTransportSecurity(
                    configuration: try processor.take("configuration", as: AppTransportSecurityConfiguration.self),
                    deviceFamilyCondition
                )
            }

            // Everything else has purposeString so just parse it once.
            let purposeString = try processor.take("purposeString", as: String.self)

            // Switch on the member and return the appropriate capability
            switch member {
            case .appTransportSecurity:
                fatalError() // already handled above
            case .bluetoothAlways:
                return .bluetoothAlways(purposeString: purposeString, deviceFamilyCondition)
            case .calendars:
                return .calendars(purposeString: purposeString, deviceFamilyCondition)
            case .camera:
                return .camera(purposeString: purposeString, deviceFamilyCondition)
            case .contacts:
                return .contacts(purposeString: purposeString, deviceFamilyCondition)
            case .faceID:
                return .faceID(purposeString: purposeString, deviceFamilyCondition)
            case .localNetwork:
                return .localNetwork(
                    purposeString: purposeString,
                    bonjourServiceTypes: try processor.takeIfDefined("bonjourServiceTypes", as: [String]?.self) ?? nil,
                    deviceFamilyCondition
                )
            case .locationAlwaysAndWhenInUse:
                return .locationAlwaysAndWhenInUse(purposeString: purposeString, deviceFamilyCondition)
            case .locationWhenInUse:
                return .locationWhenInUse(purposeString: purposeString, deviceFamilyCondition)
            case .mediaLibrary:
                return .mediaLibrary(purposeString: purposeString, deviceFamilyCondition)
            case .microphone:
                return .microphone(purposeString: purposeString, deviceFamilyCondition)
            case .motion:
                return .motion(purposeString: purposeString, deviceFamilyCondition)
            case .nearbyInteractionAllowOnce:
                return .nearbyInteractionAllowOnce(purposeString: purposeString, deviceFamilyCondition)
            case .photoLibrary:
                return .photoLibrary(purposeString: purposeString, deviceFamilyCondition)
            case .photoLibraryAdd:
                return .photoLibraryAdd(purposeString: purposeString, deviceFamilyCondition)
            case .reminders:
                return .reminders(purposeString: purposeString, deviceFamilyCondition)
            case .speechRecognition:
                return .speechRecognition(purposeString: purposeString, deviceFamilyCondition)
            case .userTracking:
                return .userTracking(purposeString: purposeString, deviceFamilyCondition)
            }
        }
    }
}

private extension ProductSetting.IOSAppInfo.Capability.Label {
    init(memberAccess: MemberAccessExprSyntax, context: SyntaxParserContext) throws {
        if let value = Self(rawValue: memberAccess.name.text) {
            self = value
        } else {
            throw context.error("'\(memberAccess.name.text)' is not a supported Capability member")
        }
    }
}
