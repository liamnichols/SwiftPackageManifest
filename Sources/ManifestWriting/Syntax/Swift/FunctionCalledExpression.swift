import Foundation

/// Used to identify the function caller expression
enum FunctionCalledExpression {
    /// Member access such as `.iOS(...`
    case memberAccess(name: Identifier)

    /// An identifier access such as `Package(...`
    case identifier(Identifier)
}
