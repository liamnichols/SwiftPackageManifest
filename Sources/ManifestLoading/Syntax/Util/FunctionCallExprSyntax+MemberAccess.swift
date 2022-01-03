import Foundation
import SwiftSyntax

extension FunctionCallExprSyntax {
    func memberAccess(_ context: SyntaxParserContext) throws -> MemberAccessExprSyntax {
        guard let memberAccess = calledExpression.as(MemberAccessExprSyntax.self) else {
            throw context.error("Function call is expected to be defined with a member access expression")
        }
        return memberAccess
    }
}
