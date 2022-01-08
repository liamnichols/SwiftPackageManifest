import ManifestDescription
import SwiftSyntax

extension Target.TargetType {
    var name: Identifier {
        switch self {
        case .regular:
            return "target"
        case .executable:
            return "executableTarget"
        }
    }
}

extension Target: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: type.name)
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = [
            FunctionCallArgument(
                label: "name",
                expression: StringLiteral(content: name)
            )
        ]

        if !dependencies.isEmpty {
            arguments.append(FunctionCallArgument(
                label: "dependencies",
                expression: ArrayLiteral(content: dependencies)
            ))
        }

        if let path = path {
            arguments.append(FunctionCallArgument(
                label: "path",
                expression: StringLiteral(content: path)
            ))
        }

        return arguments
    }
}
