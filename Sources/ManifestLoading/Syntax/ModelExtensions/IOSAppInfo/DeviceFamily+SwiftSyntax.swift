import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.DeviceFamily: ExpressibleByMemberAccessExprSyntax, TransformableFromExprSyntax {
    init(memberAccess: MemberAccessExprSyntax, context: SyntaxParserContext) throws {
        if let value = Self(rawValue: memberAccess.name.text) {
            self = value
        } else {
            throw context.error("'\(memberAccess.name.text)' is not a valid DeviceFamily type")
        }
    }
}
