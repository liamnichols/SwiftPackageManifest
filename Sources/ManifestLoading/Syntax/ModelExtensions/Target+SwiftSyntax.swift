import Foundation
import ManifestDescription
import SwiftSyntax

extension Target: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Make sure this function all looks roughly like we expect it to.
        let memberAccess = try functionCall.memberAccess(context)

        // Detect the type
        let type: TargetType
        switch memberAccess.name.text {
        case "target":
            type = .regular
        case "executableTarget":
            type = .executable
        case let other where ["systemLibrary", "plugin", "testTarget", "binaryTarget"].contains(other):
            throw context.error("Unsupported target type '\(other)'")
        case let other:
            throw context.error("Unknown target type '\(other)'")
        }

        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            Target(
                name: try processor.take("name", as: String.self),
                type: type,
                dependencies: try processor.takeIfDefined("dependencies", as: [Dependency].self) ?? [],
                path: try processor.takeIfDefined("path", as: String?.self) ?? nil
            )
        }
    }
}
