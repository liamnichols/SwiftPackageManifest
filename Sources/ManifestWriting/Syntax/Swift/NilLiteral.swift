import SwiftSyntax

struct NilLiteral: ExprSyntaxRepresentable {
    func make(leadingTrivia: Trivia) -> NilLiteralExprSyntax {
        NilLiteralExprSyntax { builder in
            builder.useNilKeyword(SyntaxFactory.makeNilKeyword(leadingTrivia: leadingTrivia, trailingTrivia: .zero))
        }
    }
}
