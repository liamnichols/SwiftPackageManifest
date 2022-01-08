import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.Capability: FunctionCallSyntaxRepresentable {
    var memberAccessName: Identifier {
        Identifier(label.rawValue)
    }

    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: memberAccessName)
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = []

        switch self {
        case .appTransportSecurity(let configuration, _):
            arguments.append(FunctionCallArgument(
                label: "configuration",
                expression: configuration
            ))

        case .localNetwork(let purposeString, let bonjourServiceTypes, _):
            arguments.append(contentsOf: [
                FunctionCallArgument(
                    label: "purposeString",
                    expression: StringLiteral(content: purposeString)
                ),
                FunctionCallArgument(
                    label: "bonjourServiceTypes",
                    expression: OptionalContent<ArrayLiteral<StringLiteral>>(
                        content: bonjourServiceTypes?.map({ StringLiteral(content: $0) })
                    )
                ),
            ])

        case .bluetoothAlways(let purposeString, _),
             .calendars(let purposeString, _),
             .camera(let purposeString, _),
             .contacts(let purposeString, _),
             .faceID(let purposeString, _),
             .locationAlwaysAndWhenInUse(let purposeString, _),
             .locationWhenInUse(let purposeString, _),
             .mediaLibrary(let purposeString, _),
             .microphone(let purposeString, _),
             .motion(let purposeString, _),
             .nearbyInteractionAllowOnce(let purposeString, _),
             .photoLibrary(let purposeString, _),
             .photoLibraryAdd(let purposeString, _),
             .reminders(let purposeString, _),
             .speechRecognition(let purposeString, _),
             .userTracking(let purposeString, _):
            arguments.append(FunctionCallArgument(
                label: "purposeString",
                expression: StringLiteral(content: purposeString)
            ))
        }

        if let condition = condition {
            arguments.append(FunctionCallArgument(label: nil, expression: condition))
        }

        return arguments
    }
}
