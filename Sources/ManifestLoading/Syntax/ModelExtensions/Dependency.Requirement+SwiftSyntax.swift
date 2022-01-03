import Foundation
import ManifestDescription
import SwiftSyntax

extension Dependency.Requirement: ExpressibleByFunctionCallExprSyntax, ExpressibleBySequenceExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Parse the value as a string literal
        guard let literalValue = functionCall.argumentList.first?.expression.stringLiteral else {
            throw context.error("Couldn't find string literal value in function call '\(functionCall.description)'")
        }

        let memberAccess = try functionCall.memberAccess(context)

        // Work out what it relates to
        switch memberAccess.name.text {
        case "exact":
            do {
                self = .exact(try Version(string: literalValue))
            } catch {
                throw context.error("Literal value was not valid version (\(error.localizedDescription))")
            }
        case "branch":
            self = .branch(literalValue)
        case "revision":
            self = .revision(literalValue)
        case let other:
            throw context.error("Unknown requirement '\(other)'")
        }
    }

    init(sequence: SequenceExprSyntax, context: SyntaxParserContext) throws {
        guard sequence.elements.count == 3 else {
            throw context.error("Expected three elements for a valid range expression")
        }

        let elements = Array(sequence.elements)
        guard let lower = elements[0].stringLiteral,
              let binaryOperator = elements[1].as(BinaryOperatorExprSyntax.self),
              let upper = elements[2].stringLiteral else {
                  throw context.error("Expected two string literals and a binary operator (..<)")
              }

        let from: Version, to: Version
        do {
            from = try Version(string: lower)
            to = try Version(string: upper)
        } catch {
            throw context.error("Literal value was not valid version (\(error.localizedDescription))")
        }

        guard binaryOperator.operatorToken.text == "..<" else {
            throw context.error("Invalid binary operator token '\(binaryOperator.operatorToken.text)'. Expected '..<'")
        }

        self = .range(from ..< to)
    }
}
