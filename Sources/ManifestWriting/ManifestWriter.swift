import Foundation
import ManifestDescription
import SwiftSyntax

public class ManifestWriter {
    public struct Options {
        /// The header comment to include when writing the manifest.
        public var header: String = """
        Generated using https://github.com/liamnichols/SwiftPackageManifest
        """

        /// If the contents should be pretty printed or not, default value is `true`.
        public var prettyPrint: Bool = true
    }

    public var options = Options()

    public init() {

    }

    public func write(_ manifest: Manifest) throws -> String {
        // Create the initial leading trivia, the swift-tools-version definition + header
        let leadingTrivia: Trivia = [
            .lineComment("// swift-tools-version: \(manifest.toolsVersion.commentRepresentation)"),
            .newlines(2)
        ] + options.headerTrivia + [
            .newlines(1)
        ]

        // Build the code block syntax for the file
        let sourceFile = SourceFileSyntax { builder in
            // Import PackageDescription + the comments
            builder.add(
                Import(identifier: "PackageDescription"),
                leadingTrivia: leadingTrivia
            )

            // If the manifest is for a Playgrounds App, include the AppleProductTypes import
            if manifest.includesAppleProductTypes {
                builder.add(
                    Import(identifier: "AppleProductTypes"),
                    leadingTrivia: .newlines(1)
                )
            }

            // Build the Package vairable decleration
            builder.add(
                PackageVariableDecl(name: "package", package: manifest.package),
                leadingTrivia: .newlines(2)
            )
        }

        if options.prettyPrint {
            return PrettyPrinter().visit(sourceFile).description
        } else {
            return sourceFile.description
        }
    }
}

extension ToolsVersion {
    var commentRepresentation: String {
        if patch == 0 {
            return "\(major).\(minor)"
        } else {
            return description
        }
    }
}

extension Manifest {
    var includesAppleProductTypes: Bool {
        package.products.contains(where: { $0.type == .iOSApplication })
    }
}

extension ManifestWriter.Options {
    var headerTrivia: Trivia {
        header
            .components(separatedBy: .newlines)
            .reduce(Trivia.zero) { trivia, line in
                return trivia
                    .appending(.lineComment("// \(line)"))
                    .appending(.newlines(1))
            }
    }
}
