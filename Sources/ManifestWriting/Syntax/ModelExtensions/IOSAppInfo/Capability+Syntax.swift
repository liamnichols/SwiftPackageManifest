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

        case .localNetwork(let promptMessage, let bonjourServiceTypes, _):
            arguments.append(contentsOf: [
                FunctionCallArgument(
                    label: "promptMessage",
                    expression: StringLiteral(content: promptMessage)
                ),
                FunctionCallArgument(
                    label: "bonjourServiceTypes",
                    expression: OptionalContent<ArrayLiteral<StringLiteral>>(
                        content: bonjourServiceTypes?.map({ StringLiteral(content: $0) })
                    )
                ),
            ])

        case .bluetoothAlways(let promptMessage, _),
             .calendars(let promptMessage, _),
             .camera(let promptMessage, _),
             .contacts(let promptMessage, _),
             .faceID(let promptMessage, _),
             .locationAlwaysAndWhenInUse(let promptMessage, _),
             .locationWhenInUse(let promptMessage, _),
             .mediaLibrary(let promptMessage, _),
             .microphone(let promptMessage, _),
             .motion(let promptMessage, _),
             .nearbyInteractionAllowOnce(let promptMessage, _),
             .photoLibrary(let promptMessage, _),
             .photoLibraryAdd(let promptMessage, _),
             .reminders(let promptMessage, _),
             .speechRecognition(let promptMessage, _),
             .userTracking(let promptMessage, _):
            arguments.append(FunctionCallArgument(
                label: "promptMessage",
                expression: StringLiteral(content: promptMessage)
            ))
        }

        if let condition = condition {
            arguments.append(FunctionCallArgument(label: nil, expression: condition))
        }

        return arguments
    }
}
