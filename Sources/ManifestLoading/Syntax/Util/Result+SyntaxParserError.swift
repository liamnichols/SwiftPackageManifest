import Foundation

extension Result where Failure == SyntaxParserError {
    static func catching(_ closure: () throws -> Success) -> Result<Success, SyntaxParserError> {
        do {
            return .success(try closure())
        } catch let error as SyntaxParserError {
            return .failure(error)
        } catch {
            assertionFailure("Should only throw SyntaxParserError types")
            return .failure(SyntaxParserError(context: .init(), message: "unknown"))
        }
    }
}
