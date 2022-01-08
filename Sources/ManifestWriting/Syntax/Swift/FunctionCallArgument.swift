import SwiftSyntax

/// Repreesnts an argument in a function call
struct FunctionCallArgument {
    let label: Identifier?
    let expression: (Trivia) -> ExprSyntax

    init<Expr: SyntaxRepresentable>(
        label: Identifier? = nil,
        expression: Expr
    ) where Expr.SyntaxType: ExprSyntaxProtocol {
        self.label = label
        self.expression = { leadingTrivia in
            ExprSyntax(expression.make(leadingTrivia: leadingTrivia))
        }
    }

    func make(isAtStart: Bool, isAtEnd: Bool) -> TupleExprElementSyntax {
        // '{label}: ...,
        TupleExprElementSyntax { builder in
            let leadingTrivia: Trivia = isAtStart ? .zero : .space
            // '{label}: '
            if let label = label {
                builder.useLabel(label.make(leadingTrivia: leadingTrivia))
                builder.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .space))
            }

            // '...'
            builder.useExpression(expression(label == nil ? leadingTrivia : .zero))

            // ','
            if !isAtEnd {
                builder.useTrailingComma(SyntaxFactory.makeCommaToken())
            }
        }
    }
}
