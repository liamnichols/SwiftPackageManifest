import Foundation
import ManifestDescription
import SwiftSyntax

extension Target.Dependency: ExpressibleByFunctionCallExprSyntax, ExpressibleByStringLiteralExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Make sure this function all looks roughly like we expect it to.
        let memberAccess = try functionCall.memberAccess(context)

        // Read the arguments and conver them into the correct target dependency
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            switch memberAccess.name.text {
            case "product":
                return .product(
                    name: try processor.take("name", as: String.self),
                    package: try processor.take("package", as: String.self)
                )

            case "target":
                return .target(
                    name: try processor.take("name", as: String.self)
                )

            case "byName":
                return .byName(
                    name: try processor.take("name", as: String.self)
                )

            case let other:
                throw context.error("Invalid expression '\(other)' for Target.Dependency declaration")
            }
        }
    }

    init(stringLiteral: StringLiteralExprSyntax, context: SyntaxParserContext) throws {
        guard let content = stringLiteral.stringContent else {
            throw context.error("String literal contains non-string segments: '\(stringLiteral.description)'")
        }

        self = .byName(name: content)
    }
}
