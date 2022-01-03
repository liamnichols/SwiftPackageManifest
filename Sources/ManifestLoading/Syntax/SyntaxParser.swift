import Foundation
import SwiftSyntax

/// Type for tracking the context when parsing
struct SyntaxParserContext: CustomStringConvertible {
    private(set) var path: [String] = []

    func next(_ location: String) -> SyntaxParserContext {
        SyntaxParserContext(path: path + [location])
    }

    var description: String {
        path.joined(separator: ".")
    }

    func error(_ message: String) -> SyntaxParserError {
        SyntaxParserError(context: self, message: message)
    }
}

/// Errors produced when parsing the syntax
struct SyntaxParserError: LocalizedError {
    let context: SyntaxParserContext
    let message: String

    var errorDescription: String? {
        "\(message) in \(context)"
    }
}
