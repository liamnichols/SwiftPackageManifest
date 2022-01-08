import SwiftSyntax

protocol FunctionCallSyntaxRepresentable: ExprSyntaxRepresentable where SyntaxType == FunctionCallExprSyntax {
    var calledExpression: FunctionCalledExpression { get }
    var arguments: [FunctionCallArgument] { get }
}

extension FunctionCallSyntaxRepresentable {
    // '{Identifier}|.{name}'
    private func calledExpression(leadingTrivia: Trivia) -> ExprSyntax {
        switch calledExpression {
        case .identifier(let identifier):
            return ExprSyntax(IdentifierExprSyntax { builder in
                builder.useIdentifier(identifier.make(leadingTrivia: leadingTrivia))
            })
        case .memberAccess(let name):
            return ExprSyntax(MemberAccessExprSyntax { builder in
                builder.useDot(SyntaxFactory.makePeriodToken(leadingTrivia: leadingTrivia))
                builder.useName(name.make())
            })
        }
    }

    func make(leadingTrivia: Trivia) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax { builder in
            // '{Identifier}|.{name}'
            builder.useCalledExpression(calledExpression(leadingTrivia: leadingTrivia))

            // '('
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())

            for (idx, argument) in arguments.enumerated() {
                let isAtStart = idx == arguments.startIndex
                let isAtEnd = idx == arguments.endIndex - 1

                // '{name}: {...},'
                builder.addArgument(
                    argument.make(isAtStart: isAtStart, isAtEnd: isAtEnd)
                )
            }

            // ')'
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
        }
    }
}
