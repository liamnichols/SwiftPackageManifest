import Foundation
import ManifestDescription
import SwiftSyntax


extension ProductSetting.IOSAppInfo.InterfaceOrientation: ExprSyntaxRepresentable {
    func make(leadingTrivia: Trivia) -> ExprSyntax {
        if condition != nil {
            return ExprSyntax(AsFunctionCall(base: self).make(leadingTrivia: leadingTrivia))
        } else {
            return ExprSyntax(AsMemberAccess(base: self).make(leadingTrivia: leadingTrivia))
        }
    }
}

private extension ProductSetting.IOSAppInfo.InterfaceOrientation {
    var memberAccessName: Identifier {
        Identifier(label.rawValue)
    }
}

private extension ProductSetting.IOSAppInfo.InterfaceOrientation {
    struct AsMemberAccess: ExprSyntaxRepresentable {
        let base: ProductSetting.IOSAppInfo.InterfaceOrientation

        func make(leadingTrivia: Trivia) -> MemberAccessExprSyntax {
            MemberAccessExprSyntax { builder in
                builder.useDot(SyntaxFactory.makePeriodToken(leadingTrivia: leadingTrivia))
                builder.useName(base.memberAccessName.make())
            }
        }
    }

    struct AsFunctionCall: FunctionCallSyntaxRepresentable {
        let base: ProductSetting.IOSAppInfo.InterfaceOrientation

        var calledExpression: FunctionCalledExpression {
            .memberAccess(name: base.memberAccessName)
        }

        var arguments: [FunctionCallArgument] {
            guard let condition = base.condition else { return [] }
            return [
                FunctionCallArgument(label: nil, expression: condition)
            ]
        }
    }
}
