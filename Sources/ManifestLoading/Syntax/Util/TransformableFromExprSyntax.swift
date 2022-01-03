import Foundation
import SwiftSyntax

protocol TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> Self
}

extension Optional: TransformableFromExprSyntax where Wrapped: TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> Optional<Wrapped> {
        try expression.parseNilLiteral { expression in
            try Wrapped.transform(from: expression, using: context)
        }
    }
}

extension String: TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> String {
        try expression.parseStringLiteral(in: context)
    }
}

extension Bool: TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> Bool {
        try expression.parseBoolLiteral(in: context)
    }
}

extension URL: TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> URL {
        if let url = URL(string: try .transform(from: expression, using: context)) { return url }
        throw context.error("Expression cannot be represented as a literal string in a URL format")
    }
}

extension Array: TransformableFromExprSyntax where Element: TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> Array<Element> {
        try expression.parseArrayLiteral(in: context) { context, expression in
            try Element.transform(from: expression, using: context)
        }
    }
}

extension Dictionary: TransformableFromExprSyntax where Key: TransformableFromExprSyntax, Value: TransformableFromExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> Dictionary<Key, Value> {
        try expression.parseDictionaryLiteral(
            in: context,
            keyContent: { context, expression in
                try Key.transform(from: expression, using: context)
            },
            valueContent: { context, expression in
                try Value.transform(from: expression, using: context)
            }
        )
    }
}

extension TransformableFromExprSyntax where Self: ExpressibleByExprSyntax {
    static func transform(from expression: ExprSyntax, using context: SyntaxParserContext) throws -> Self {
        try Self.init(expression: expression, context: context)
    }
}
