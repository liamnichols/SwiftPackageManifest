import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: "init")
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = []

        if let allowsArbitraryLoadsInWebContent = allowsArbitraryLoadsInWebContent {
            arguments.append(FunctionCallArgument(
                label: "allowsArbitraryLoadsInWebContent",
                expression: BooleanLiteral(content: allowsArbitraryLoadsInWebContent)
            ))
        }

        if let allowsArbitraryLoadsForMedia = allowsArbitraryLoadsForMedia {
            arguments.append(FunctionCallArgument(
                label: "allowsArbitraryLoadsForMedia",
                expression: BooleanLiteral(content: allowsArbitraryLoadsForMedia)
            ))
        }

        if let allowsLocalNetworking = allowsLocalNetworking {
            arguments.append(FunctionCallArgument(
                label: "allowsLocalNetworking",
                expression: BooleanLiteral(content: allowsLocalNetworking)
            ))
        }

        if let exceptionDomains = exceptionDomains {
            arguments.append(FunctionCallArgument(
                label: "exceptionDomains",
                expression: ArrayLiteral(content: exceptionDomains)
            ))
        }

        if let pinnedDomains = pinnedDomains {
            arguments.append(FunctionCallArgument(
                label: "pinnedDomains",
                expression: ArrayLiteral(content: pinnedDomains)
            ))
        }

        return arguments
    }
}
