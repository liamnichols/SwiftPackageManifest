import Foundation
import ManifestDescription
import SwiftSyntax

extension Dependency: FunctionCallSyntaxRepresentable {
    var name: String? {
        switch self {
        case .fileSystem(let name, _), .sourceControl(let name, _, _):
            return name
        }
    }

    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: "package")
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = []

        if let name = name {
            arguments.append(FunctionCallArgument(
                label: "name",
                expression: StringLiteral(content: name)
            ))
        }

        switch self {
        case .sourceControl(_, let url, let requirement):
            arguments.append(contentsOf: [
                FunctionCallArgument(label: "url", expression: StringLiteral(content: url.absoluteString)),
                FunctionCallArgument(label: nil, expression: requirement)
            ])

        case .fileSystem(_, let path):
            arguments.append(contentsOf: [
                FunctionCallArgument(label: "path", expression: StringLiteral(content: path))
            ])
        }

        return arguments
    }
}
