import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.DeviceFamily: ExprSyntaxRepresentable {
    func make(leadingTrivia: Trivia) -> MemberAccessExprSyntax {
        MemberAccessExprSyntax { builder in
            builder.useDot(SyntaxFactory.makePeriodToken(leadingTrivia: leadingTrivia))
            builder.useName(Identifier(rawValue).make())
        }
    }
}
