import Foundation
import ManifestDescription
import SwiftSyntax

extension Platform: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Make sure this function all looks roughly like we expect it to.
        let memberAccess = try functionCall.memberAccess(context)

        // Parse the value as a string literal
        guard let expression = functionCall.argumentList.first?.expression else {
            throw context.error("Missing expression")
        }

        // TODO: Will eventually need to add some more type safety once it's better defined.
        let literalValue = try expression.parseStringLiteral(in: context)
        self = Platform(name: memberAccess.name.text, oldestSupportedVersion: Version(value: literalValue))
    }
}
