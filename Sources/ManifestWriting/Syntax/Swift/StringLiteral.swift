import SwiftSyntax

struct StringLiteral: ExprSyntaxRepresentable, ContentProviding {
    let content: String

    func make(leadingTrivia: Trivia) -> some ExprSyntaxProtocol {
        StringLiteralExprSyntax { builder in
            // '"'
            builder.useOpenQuote(
                SyntaxFactory.makeStringQuoteToken(leadingTrivia: leadingTrivia, trailingTrivia: .zero)
            )

            // '{content}'
            builder.addSegment(Syntax(StringSegmentSyntax{ builder in
                builder.useContent(SyntaxFactory.makeStringSegment(content))
            }))

            // '"'
            builder.useCloseQuote(SyntaxFactory.makeStringQuoteToken())
        }
    }
}
