import SwiftSyntax

extension ExprSyntax {
    var isNilLiteral: Bool {
        self.is(NilLiteralExprSyntax.self)
    }

    var stringLiteral: String? {
        self.as(StringLiteralExprSyntax.self)?.stringContent
    }

    func parseBoolLiteral(in context: SyntaxParserContext) throws -> Bool {
        guard let literalExpr = self.as(BooleanLiteralExprSyntax.self) else {
            throw context.error("Expected BooleanLiteralExprSyntax but got \(self.syntaxNodeType)")
        }

        switch literalExpr.booleanLiteral.text {
        case "true":
            return true
        case "false":
            return false
        case let other:
            throw context.error("Expected 'true' or 'false', got '\(other)'")
        }
    }

    func parseStringLiteral(in context: SyntaxParserContext) throws -> String {
        guard let literalExpr = self.as(StringLiteralExprSyntax.self) else {
            throw context.error("Expected StringLiteralExprSyntax but got \(self.syntaxNodeType)")
        }

        guard let content = literalExpr.stringContent else {
            throw context.error("Literal string contained invalid segments (maybe string interpolation?)")
        }

        return content
    }

    func parseArrayLiteral<C>(
        in context: SyntaxParserContext,
        content: (SyntaxParserContext, ExprSyntax) throws -> C
    ) throws -> [C] {
        guard let arrayExpr = self.as(ArrayExprSyntax.self) else {
            throw context.error("Expected ArrayExprSyntax but got \(self.syntaxNodeType)")
        }

        var elements: [C] = []

        for (idx, element) in arrayExpr.elements.enumerated() {
            // Build a context with the element index
            var path = context.path
            let lastPath = path.removeLast()
            path.append(lastPath + "[\(idx)]")
            let context = SyntaxParserContext(path: path)

            // Map the content
            elements.append(try content(context, element.expression))
        }

        return elements
    }

    func parseDictionaryLiteral<Key: Hashable, Value>(
        in context: SyntaxParserContext,
        keyContent: (SyntaxParserContext, ExprSyntax) throws -> Key,
        valueContent: (SyntaxParserContext, ExprSyntax) throws -> Value
    ) throws -> [Key: Value] {
        guard let dictionaryExpr = self.as(DictionaryExprSyntax.self) else {
            throw context.error("Expected DictionaryExprSyntax but got \(self.syntaxNodeType)")
        }

        var contents: [Key: Value] = [:]

        for (idx, element) in dictionaryExpr.elements.enumerated() {
            // Build a context with the element index
            var path = context.path
            let lastPath = path.removeLast()
            path.append(lastPath + "[\(idx)]")
            let context = SyntaxParserContext(path: path)

            // Map the content
            contents[try keyContent(context, element.keyExpression)] = try valueContent(context, element.valueExpression)
        }

        return contents
    }

    func parseNilLiteral<C>(
        otherwise: (ExprSyntax) throws -> C
    ) throws -> C? {
        if self.isNilLiteral {
            return nil
        }

        return try otherwise(self)
    }
}

extension StringLiteralExprSyntax {
    var stringContent: String? {
        var content: String = ""

        for segment in segments {
            guard let string = segment.as(StringSegmentSyntax.self) else {
                return nil // this could have been ExpressionSegmentSyntax
            }

            content += string.content.text
        }

        return content
    }
}

extension DictionaryExprSyntax {
    public var elements: DictionaryElementListSyntax {
        DictionaryElementListSyntax(content._syntaxNode)!
    }
}
