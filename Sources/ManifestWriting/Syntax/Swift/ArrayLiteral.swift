import SwiftSyntax

struct ArrayLiteral<Element: ExprSyntaxRepresentable>: ExprSyntaxRepresentable, ContentProviding {
    let content: [Element]

    func make(leadingTrivia: Trivia) -> ArrayExprSyntax {
        ArrayExprSyntax { builder in
            // '['
            builder.useLeftSquare(SyntaxFactory.makeLeftSquareBracketToken(leadingTrivia: leadingTrivia))

            for (idx, item) in content.enumerated() {
                builder.addElement(ArrayElementSyntax { builder in
                    // '{...}'
                    builder.useExpression(ExprSyntax(item.make()))

                    // ', '
                    let isAtEnd = idx == content.endIndex - 1
                    if !isAtEnd {
                        builder.useTrailingComma(SyntaxFactory.makeCommaToken(trailingTrivia: .space))
                    }
                })
            }

            // ']'
            builder.useRightSquare(SyntaxFactory.makeRightSquareBracketToken())
        }
    }
}
