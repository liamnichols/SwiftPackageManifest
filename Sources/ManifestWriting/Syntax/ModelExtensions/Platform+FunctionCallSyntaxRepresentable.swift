import ManifestDescription
import SwiftSyntax

extension Platform: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: Identifier(name))
    }

    var arguments: [FunctionCallArgument] {
        [
            FunctionCallArgument(label: nil, expression: StringLiteral(content: oldestSupportedVersion.value))
        ]
    }
}
