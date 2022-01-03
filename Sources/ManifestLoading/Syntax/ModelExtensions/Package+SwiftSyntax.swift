import Foundation
import ManifestDescription
import SwiftSyntax

extension Package: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        let identifier = functionCall.calledExpression.as(IdentifierExprSyntax.self)?.identifier.text
        guard identifier == "Package" else {
            throw context.error("Function Call is not an initializer for type 'Package'")
        }

        // Process the arguments defined
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            return Package(
                name: try processor.take("name", as: String.self),
                defaultLocalization: try processor.takeIfDefined("defaultLocalization", as: String?.self) ?? nil,
                platforms: try processor.takeIfDefined("platforms", as: [Platform]?.self) ?? nil,
                pkgConfig: try processor.takeIfDefined("pkgConfig", as: String?.self) ?? nil,
                products: try processor.takeIfDefined("products", as: [Product].self) ?? [],
                dependencies: try processor.takeIfDefined("dependencies", as: [Dependency].self) ?? [],
                targets: try processor.takeIfDefined("targets", as: [Target].self) ?? [],
                cLanguageStandard: try processor.takeIfDefined("cLanguageStandard", as: String?.self) ?? nil,
                cxxLanguageStandard: try processor.takeIfDefined("cxxLanguageStandard", as: String?.self) ?? nil
            )
        }
    }
}
