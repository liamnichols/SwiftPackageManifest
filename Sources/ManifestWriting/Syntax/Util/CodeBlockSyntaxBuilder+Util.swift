import Foundation
import SwiftSyntax

extension SourceFileSyntaxBuilder {
    mutating func addCodeBlockItem(_ syntax: SyntaxProtocol) {
        addStatement(CodeBlockItemSyntax { builder in
            builder.useItem(syntax._syntaxNode)
        })
    }

    mutating func add<S: SyntaxRepresentable>(_ syntax: S, leadingTrivia: Trivia = .zero) {
        addCodeBlockItem(syntax.make(leadingTrivia: leadingTrivia))
    }
}
