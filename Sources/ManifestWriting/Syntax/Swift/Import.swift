import SwiftSyntax

struct Import: SyntaxRepresentable {
    let identifier: Identifier

    func make(leadingTrivia: Trivia) -> some SyntaxProtocol {
        ImportDeclSyntax { builder in
            // 'import '
            let keyword = SyntaxFactory.makeImportKeyword(leadingTrivia: leadingTrivia, trailingTrivia: .spaces(1))
            builder.useImportTok(keyword)

            // '{identifier}'
            builder.addPathComponent(AccessPathComponentSyntax { builder in
                builder.useName(identifier.make())
            })
        }
    }
}
