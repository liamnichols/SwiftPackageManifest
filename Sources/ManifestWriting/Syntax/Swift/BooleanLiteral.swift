import SwiftSyntax

struct BooleanLiteral: ExprSyntaxRepresentable, ContentProviding {
    let content: Bool

    func make(leadingTrivia: Trivia) -> some ExprSyntaxProtocol {
        BooleanLiteralExprSyntax { builder in
            if content {
                builder.useBooleanLiteral(SyntaxFactory.makeTrueKeyword())
            } else {
                builder.useBooleanLiteral(SyntaxFactory.makeFalseKeyword())
            }
        }
    }
}
