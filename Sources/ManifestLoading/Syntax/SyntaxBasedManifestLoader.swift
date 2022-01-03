import Foundation
import ManifestDescription
import SwiftSyntax

/// A `ManifestLoading` implementation that uses SwiftSyntax to parse the AST to extract literal values..
/// This implementation is considerabbly less reliable than `XcodeBasedManifestLoader`, but works on iOS.
public class SyntaxBasedManifestLoader: ManifestLoader {
    public init() {
    }

    public func load(at fileURL: URL) throws -> Manifest {
        // Load the source file, avoid using `String(contentsOf:)` because it creates a wrapped NSString.
        let fileData = try Data(contentsOf: fileURL)
        let source = fileData.withUnsafeBytes {
            String(decoding: $0.bindMemory(to: UInt8.self), as: UTF8.self)
        }

        // Find the ToolsVersion
        let toolsVersion = try detectToolsVersion(in: source)

        // Parse the AST and walk through to parse the Package contents
        let sourceFile = try SwiftSyntax.SyntaxParser.parse(source: source, filenameForDiagnostics: fileURL.path)
        let collector = ManifestCollector()
        collector.walk(sourceFile)

        // Read the collected values
        let package = try collector.package.get()

        // Throw an error
        return Manifest(toolsVersion: toolsVersion, package: package)
    }

    private func detectToolsVersion(in source: String) throws -> ToolsVersion {
        let regex = try NSRegularExpression(pattern: #"swift-tools-version:\s(.*)"#, options: [])
        let range = NSRange(source.startIndex ..< source.endIndex, in: source)

        guard let match = regex.firstMatch(in: source, options: [], range: range) else {
            throw StringError("swift-tools-version was not defined")
        }

        let valueRange = match.range(at: 1)
        guard let range = Range(valueRange, in: source) else {
            throw StringError("")
        }

        let version = try Version(string: String(source[range]), usesLenientParsing: true)
        return ToolsVersion(version: version)
    }
}

private class ManifestCollector: SyntaxVisitor {
    let context = SyntaxParserContext()

    private(set) lazy var package: Result<Package, SyntaxParserError> = .failure(
        context.error("Package definition not found")
    )

    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        let identifier = node.calledExpression.as(IdentifierExprSyntax.self)?.identifier.text

        if identifier == "Package" {
            package = .catching { try Package(functionCall: node, context: context.next("Package")) }
            return .skipChildren
        }

        return .visitChildren
    }
}
