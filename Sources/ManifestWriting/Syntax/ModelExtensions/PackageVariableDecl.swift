import ManifestDescription
import SwiftSyntax

struct PackageVariableDecl: SyntaxRepresentable {
    let name: Identifier
    let package: Package

    func make(leadingTrivia: Trivia) -> some SyntaxProtocol {
        VariableDeclSyntax { builder in
            // 'let'
            builder.useLetOrVarKeyword(
                SyntaxFactory.makeLetKeyword(leadingTrivia: leadingTrivia, trailingTrivia: .space)
            )

            // '{name} = Package(...)'
            builder.addBinding(SyntaxFactory.makePatternBinding(
                // '{name}'
                pattern: PatternSyntax(IdentifierPatternSyntax { builder in
                    builder.useIdentifier(name.make())
                }),
                typeAnnotation: nil,
                initializer: InitializerClauseSyntax { builder in
                    // ' = '
                    builder.useEqual(SyntaxFactory.makeEqualToken(leadingTrivia: .space, trailingTrivia: .space))

                    // 'Package(...)'
                    builder.useValue(ExprSyntax(package.make(leadingTrivia: .zero)))
                },
                accessor: nil,
                trailingComma: nil
            ))
        }
    }
}
