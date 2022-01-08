import Foundation
import ManifestDescription
import SwiftSyntax

extension Dependency.Requirement: ExprSyntaxRepresentable {
    func make(leadingTrivia: Trivia) -> ExprSyntax {
        switch self {
        case .range(let range):
            return ExprSyntax(AsRangeLiteral(range: range).make(leadingTrivia: leadingTrivia))
        case let other:
            return ExprSyntax(AsFunctionCall(base: other).make(leadingTrivia: leadingTrivia))
        }
    }
}

private extension Dependency.Requirement {
    struct AsRangeLiteral: ExprSyntaxRepresentable {
        let range: Range<Version>

        func make(leadingTrivia: Trivia) -> SequenceExprSyntax {
            SequenceExprSyntax { builder in
                // ' "0.0.1"'
                builder.addElement(
                    ExprSyntax(StringLiteral(content: range.lowerBound.description).make(leadingTrivia: leadingTrivia))
                )

                // '..<'
                builder.addElement(ExprSyntax(BinaryOperatorExprSyntax { builder in
                    builder.useOperatorToken(SyntaxFactory.makeBinaryOperator("..<"))
                }))

                // '"1.0.0"'
                builder.addElement(
                    ExprSyntax(StringLiteral(content: range.upperBound.description).make())
                )
            }
        }
    }

    struct AsFunctionCall: FunctionCallSyntaxRepresentable {
        let base: Dependency.Requirement

        var memberAccessName: Identifier {
            switch base {
            case .exact:
                return "exact"
            case .range:
                return "rangeItem"
            case .revision:
                return "revision"
            case .branch:
                return "branch"
            }
        }

        var calledExpression: FunctionCalledExpression {
            .memberAccess(name: memberAccessName)
        }

        var arguments: [FunctionCallArgument] {
            switch base {
            case .exact(let version):
                return [FunctionCallArgument(label: nil, expression: StringLiteral(content: version.description))]
            case .revision(let revision):
                return [FunctionCallArgument(label: nil, expression: StringLiteral(content: revision))]
            case .branch(let branch):
                return [FunctionCallArgument(label: nil, expression: StringLiteral(content: branch))]
            case .range(let range):
                return [FunctionCallArgument(label: nil, expression: AsRangeLiteral(range: range))]
            }
        }
    }
}

