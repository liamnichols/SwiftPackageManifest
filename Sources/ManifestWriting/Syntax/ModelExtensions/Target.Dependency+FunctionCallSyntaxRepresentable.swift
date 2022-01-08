import ManifestDescription
import SwiftSyntax

extension Target.Dependency: ExprSyntaxRepresentable {
    func make(leadingTrivia: Trivia) -> ExprSyntax {
        switch self {
        // By default `byName` should be represented as a string literal
        case .byName(let name):
            return ExprSyntax(StringLiteral(content: name).make(leadingTrivia: leadingTrivia))

        // Other types should represent as a function call
        case let other:
            return ExprSyntax(AsFunctionCall(base: other).make(leadingTrivia: leadingTrivia))
        }
    }
}

private extension Target.Dependency {
    struct AsFunctionCall: FunctionCallSyntaxRepresentable {
        let base: Target.Dependency

        var name: String {
            switch base {
            case .target(let name), .product(let name, _), .byName(let name):
                return name
            }
        }

        var calledExpression: FunctionCalledExpression {
            switch base {
            case .target:
                return .memberAccess(name: "target")
            case .product:
                return .memberAccess(name: "product")
            case .byName:
                return .memberAccess(name: "byName")
            }
        }

        var arguments: [FunctionCallArgument] {
            var arguments: [FunctionCallArgument] = [
                FunctionCallArgument(
                    label: "name",
                    expression: StringLiteral(content: name)
                )
            ]

            if case .product(_, let package) = base {
                arguments.append(FunctionCallArgument(
                    label: "package",
                    expression: StringLiteral(content: package)
                ))
            }

            return arguments
        }
    }
}
