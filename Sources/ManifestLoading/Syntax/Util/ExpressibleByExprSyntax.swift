import Foundation
import SwiftSyntax

protocol ExpressibleByExprSyntax {
    init(expression: ExprSyntax, context: SyntaxParserContext) throws
}

extension ExpressibleByExprSyntax {
    init(expression: ExprSyntax, context: SyntaxParserContext) throws {
        self = try Self.parse(from: expression, context: context)
    }

    private static func parse(from expression: ExprSyntax, context: SyntaxParserContext) throws -> Self {
        // Function Calls
        if let type = self as? ExpressibleByFunctionCallExprSyntax.Type,
           let functionCall = expression.as(FunctionCallExprSyntax.self) {
            return try type.init(functionCall: functionCall, context: context) as! Self
        }

        // String Literal
        if let type = self as? ExpressibleByStringLiteralExprSyntax.Type,
           let stringLiteral = expression.as(StringLiteralExprSyntax.self) {
            return try type.init(stringLiteral: stringLiteral, context: context) as! Self
        }

        // Member Access
        if let type = self as? ExpressibleByMemberAccessExprSyntax.Type,
           let memberAccess = expression.as(MemberAccessExprSyntax.self) {
            return try type.init(memberAccess: memberAccess, context: context) as! Self
        }

        // Sequence
        if let type = self as? ExpressibleBySequenceExprSyntax.Type,
           let sequence = expression.as(SequenceExprSyntax.self) {
            return try type.init(sequence: sequence, context: context) as! Self
        }

        throw context.error("Type '\(self)' cannot be expressed by type '\(expression.syntaxNodeType)'")
    }
}

protocol ExpressibleByFunctionCallExprSyntax: ExpressibleByExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws
}

protocol ExpressibleByStringLiteralExprSyntax: ExpressibleByExprSyntax {
    init(stringLiteral: StringLiteralExprSyntax, context: SyntaxParserContext) throws
}

protocol ExpressibleByMemberAccessExprSyntax: ExpressibleByExprSyntax {
    init(memberAccess: MemberAccessExprSyntax, context: SyntaxParserContext) throws
}

protocol ExpressibleBySequenceExprSyntax: ExpressibleByExprSyntax {
    init(sequence: SequenceExprSyntax, context: SyntaxParserContext) throws
}
