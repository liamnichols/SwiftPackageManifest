import Foundation
import ManifestDescription
import SwiftSyntax

struct DictionaryLiteral<Key: ExprSyntaxRepresentable, Value: ExprSyntaxRepresentable>: ExprSyntaxRepresentable, ContentProviding {
    let content: [(key: Key, value: Value)]

    func make(leadingTrivia: Trivia) -> DictionaryExprSyntax {
        DictionaryExprSyntax { builder in
            // '['
            builder.useLeftSquare(SyntaxFactory.makeLeftSquareBracketToken(leadingTrivia: leadingTrivia))

            var elements: [DictionaryElementSyntax] = []
            for (idx, (key, value)) in content.enumerated() {
                elements.append(DictionaryElementSyntax { builder in
                    builder.useKeyExpression(ExprSyntax(key.make()))
                    builder.useColon(SyntaxFactory.makeColonToken(trailingTrivia: .space))
                    builder.useValueExpression(ExprSyntax(value.make()))

                    let isAtEnd = idx == content.endIndex - 1
                    if !isAtEnd {
                        builder.useTrailingComma(SyntaxFactory.makeCommaToken(trailingTrivia: .space))
                    }
                })
            }

            // '...'
            builder.useContent(SyntaxFactory.makeDictionaryElementList(elements)._syntaxNode)

            // ']'
            builder.useRightSquare(SyntaxFactory.makeRightSquareBracketToken())
        }
    }
}

extension ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration.PinnedDomain: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: "init")
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = [
            FunctionCallArgument(label: "domainName", expression: StringLiteral(content: domainName))
        ]

        if let includesSubdomains = includesSubdomains {
            arguments.append(FunctionCallArgument(
                label: "includesSubdomains",
                expression: BooleanLiteral(content: includesSubdomains)
            ))
        }

        if let pinnedCAIdentities = pinnedCAIdentities {
            arguments.append(FunctionCallArgument(
                label: "pinnedCAIdentities",
                expression: ArrayLiteral<DictionaryLiteral<StringLiteral, StringLiteral>>(
                    content: pinnedCAIdentities.map { array in
                        DictionaryLiteral(
                            content: array
                                .map({ (StringLiteral(content: $0.key), StringLiteral(content: $0.value)) })
                        )
                    }
                )
            ))
        }

        if let pinnedLeafIdentities = pinnedLeafIdentities {
            arguments.append(FunctionCallArgument(
                label: "pinnedLeafIdentities",
                expression: ArrayLiteral<DictionaryLiteral<StringLiteral, StringLiteral>>(
                    content: pinnedLeafIdentities.map { array in
                        DictionaryLiteral(
                            content: array
                                .map({ (StringLiteral(content: $0.key), StringLiteral(content: $0.value)) })
                        )
                    }
                )
            ))
        }

        return arguments
    }
}
