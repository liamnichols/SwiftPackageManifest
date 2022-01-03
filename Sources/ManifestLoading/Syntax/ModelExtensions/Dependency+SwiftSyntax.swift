import Foundation
import SwiftSyntax
import ManifestDescription

extension Dependency: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Make sure this function all looks roughly like we expect it to.
        let memberAccess = try functionCall.memberAccess(context)
        guard memberAccess.name.text == "package" else {
            throw context.error("Expected caller expression '.package(...)', got '\(memberAccess.description.trimmingCharacters(in: .whitespacesAndNewlines))'")
        }

        // Process the arguments defined
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            if processor.argumentLabels.contains("url") {
                return Dependency(
                    name: try processor.takeIfDefined("name", as: String?.self) ?? nil,
                    url: try processor.take("url", as: URL.self),
                    requirement: try processor.take(nil, as: Requirement.self)
                )
            } else {
                return Dependency(
                    name: try processor.takeIfDefined("name", as: String?.self) ?? nil,
                    path: try processor.take("path", as: String.self)
                )
            }
        }
    }
}
