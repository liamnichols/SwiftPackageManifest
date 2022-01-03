import Foundation
import SwiftSyntax

class SyntaxArgumentProcessor {
    private let context: SyntaxParserContext
    private var arguments: [String?: ExprSyntax]
    let argumentLabels: Set<String?>
    private var takenLabels: Set<String?> = []

    static func process<T>(
        argumentList: TupleExprElementListSyntax,
        in context: SyntaxParserContext,
        process: (SyntaxArgumentProcessor) throws -> T
    ) throws -> T {
        let processor = try SyntaxArgumentProcessor(argumentList: argumentList, context: context)
        let value = try process(processor)
        try processor.assertDone()
        return value
    }

    private init(argumentList: TupleExprElementListSyntax, context: SyntaxParserContext) throws {
        self.context = context
        self.arguments = try Dictionary(argumentList.map({ ($0.label?.text, $0.expression) }), uniquingKeysWith: { _, _ in
            throw context.error("Duplicate argument labels are not supported")
        })
        self.argumentLabels = Set(self.arguments.keys)
    }

    /// call after taking arguments to assert that nothing unexpected was left
    private func assertDone() throws {
        if !arguments.isEmpty {
            let list = arguments.keys.map { "'\($0 ?? "_")'" }
            throw context.error("Unexpected arguments \(list.formatted(.list(type: .and)))")
        }
    }

    /*
     * Nil Literal Handling
     * ====================
     *
     * Parse   | Value | Method        |Expectation
     * --------|-------|---------------|-------------------------------------------------------------
     * String  | "foo" | takeIfDefined | Return `"foo"`
     * String? | "foo" | takeIfDefined | Return `"foo"`
     * String  | nil   | takeIfDefined | Throw error (it can't be nil)
     * String? | nil   | takeIfDefined | Return `nil` (it was a nil literal)
     * String  |       | takeIfDefined | Return `nil` (it wasn't defined)
     * String? |       | takeIfDefined | Return `nil` (it wasn't defined)
     *         |       |               |
     * String  | "foo" | take          | Return `"foo"`
     * String? | "foo" | take          | Return `"foo"`
     * String  | nil   | take          | Throw error (it can't be nil)
     * String? | nil   | take          | Return `nil` (nil literal, optional type suggest supported)
     * String  |       | take          | Throw error (it can't be nil and it wasn't defined)
     * String? |       | take          | Throw error (it can't be nil and it wasn't defined)
     */

    /// Takes the expression with the given label, or returns `nil` if it wasn't defined (an optional argument)
    func takeIfDefined(_ label: String?) -> ExprSyntax? {
        takeIfDefined(label, transformer: { expression, _ in expression })
    }

    func takeIfDefined<T: TransformableFromExprSyntax>(_ label: String?, as: T.Type) throws -> T? {
        try takeIfDefined(label, transformer: T.transform(from:using:))
    }

    private func takeIfDefined<T>(
        _ label: String?,
        transformer: (ExprSyntax, SyntaxParserContext) throws -> T
    ) rethrows -> T? {
        takenLabels.insert(label)

        return try arguments
            .removeValue(forKey: label)
            .flatMap { try transformer($0, context.next(label ?? "_")) }
    }

    /// Takes the expression with the given label or throws if the argument doesn't exist
    func take(_ label: String?) throws -> ExprSyntax {
        try take(label, transformer: { expression, _ in expression })
    }

    func take<T: TransformableFromExprSyntax>(_ label: String?, as: T.Type) throws -> T {
        try take(label, transformer: T.transform(from:using:))
    }

    private func take<T>(_ label: String?, transformer: (ExprSyntax, SyntaxParserContext) throws -> T) throws -> T {
        if takenLabels.contains(label) {
            preconditionFailure("attempting to take value for label '\(label ?? "_")' after it has already been taken")
        }

        guard let expression = arguments.removeValue(forKey: label) else {
            throw context.error("Argument '\(label ?? "_")' not defined")
        }

        takenLabels.insert(label)

        return try transformer(expression, context.next(label ?? "_"))
    }
}
