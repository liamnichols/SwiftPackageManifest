import ManifestDescription
import SwiftSyntax

extension Package: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .identifier("Package")
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = [
            FunctionCallArgument(
                label: "name",
                expression: StringLiteral(content: name)
            )
        ]

        if let defaultLocalization = defaultLocalization {
            // TODO: Check LanguageTag type
            arguments.append(FunctionCallArgument(
                label: "defaultLocalization",
                expression: StringLiteral(content: defaultLocalization)
            ))
        }

        if let platforms = platforms {
            arguments.append(FunctionCallArgument(
                label: "platforms",
                expression: ArrayLiteral(content: platforms)
            ))
        }

        if let pkgConfig = pkgConfig {
            arguments.append(FunctionCallArgument(
                label: "pkgConfig",
                expression: StringLiteral(content: pkgConfig)
            ))
        }

        if !products.isEmpty {
            arguments.append(FunctionCallArgument(
                label: "products",
                expression: ArrayLiteral(content: products)
            ))
        }

        if !dependencies.isEmpty {
            arguments.append(FunctionCallArgument(
                label: "dependencies",
                expression: ArrayLiteral(content: dependencies)
            ))
        }

        if !targets.isEmpty {
            arguments.append(FunctionCallArgument(
                label: "targets",
                expression: ArrayLiteral(content: targets)
            ))
        }

        if let cLanguageStandard = cLanguageStandard {
            // TODO: Check CLanguageStandard type
            arguments.append(FunctionCallArgument(
                label: "cLanguageStandard",
                expression: OptionalContent<StringLiteral>(content: cLanguageStandard)
            ))
        }

        if let cxxLanguageStandard = cLanguageStandard {
            // TODO: Check CXXLanguageStandard type
            arguments.append(FunctionCallArgument(
                label: "cxxLanguageStandard",
                expression: OptionalContent<StringLiteral>(content: cxxLanguageStandard)
            ))
        }

        return arguments
    }
}
