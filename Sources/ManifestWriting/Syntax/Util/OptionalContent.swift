import Foundation
import SwiftSyntax

/// Wraps a `SyntaxRepresentableWithContent` type with an optional value to provide convenient `NilLiteral` substitution if required.
struct OptionalContent<Wrapped: ExprSyntaxRepresentable & ContentProviding>: SyntaxRepresentable, ContentProviding {
    let content: Wrapped.Content?

    init(content: Wrapped.Content?) {
        self.content = content
    }

    func make(leadingTrivia: Trivia) -> ExprSyntax {
        if let content = content {
            return ExprSyntax(Wrapped(content: content).make(leadingTrivia: leadingTrivia))
        } else {
            return ExprSyntax(NilLiteral().make(leadingTrivia: leadingTrivia))
        }
    }
}
