import SwiftSyntax

/// A type that represents a specific piece of syntax.
protocol SyntaxRepresentable {
    /// The type of syntax repreesnted by the given type.
    associatedtype SyntaxType: SyntaxProtocol

    /// Produce the syntax type using the given leading trivia.
    func make(leadingTrivia: Trivia) -> SyntaxType
}

extension SyntaxRepresentable {
    /// Produce the syntax type with zero leading trivia.
    func make() -> SyntaxType {
        make(leadingTrivia: .zero)
    }
}
