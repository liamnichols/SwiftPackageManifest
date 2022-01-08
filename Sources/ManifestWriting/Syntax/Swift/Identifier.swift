import SwiftSyntax

struct Identifier: SyntaxRepresentable, ExpressibleByStringLiteral {
    var text: String

    init(stringLiteral value: StringLiteralType) {
        self.text = value
    }

    init(_ value: String) {
        self.text = value
    }

    func make(leadingTrivia: Trivia) -> TokenSyntax {
        SyntaxFactory.makeIdentifier(text, leadingTrivia: leadingTrivia)
    }
}
