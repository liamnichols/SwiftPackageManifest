import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.InterfaceOrientation: ExpressibleByMemberAccessExprSyntax, ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(memberAccess: MemberAccessExprSyntax, context: SyntaxParserContext) throws {
        switch try MemberAccessName(memberAccess: memberAccess, context: context) {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeRight:
            self = .landscapeRight
        case .landscapeLeft:
            self = .landscapeLeft
        }
    }

    // DeviceFamilyCondition
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // There must always be a member access expression to define the function call
        let memberAccess = try functionCall.memberAccess(context)

        // If there were no arguments, the condition wasn't set to just init with the member access
        if functionCall.argumentList.isEmpty {
            try self.init(memberAccess: memberAccess, context: context)
            return
        }

        // Attempt to parse the condition
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            typealias DeviceFamilyCondition = ProductSetting.IOSAppInfo.DeviceFamilyCondition

            // If there was an unlabeled argument, but it was a nil literal, just base the value on member access
            guard let condition = try processor.take(nil, as: DeviceFamilyCondition?.self) ?? nil else {
                return try Self(memberAccess: memberAccess, context: context)
            }

            // Read the member access name anyway
            switch try MemberAccessName(memberAccess: memberAccess, context: context) {
            case .portrait:
                return .portrait(condition)
            case .portraitUpsideDown:
                return .portraitUpsideDown(condition)
            case .landscapeRight:
                return .landscapeRight(condition)
            case .landscapeLeft:
                return .landscapeLeft(condition)
            }
        }
    }
}

private extension ProductSetting.IOSAppInfo.InterfaceOrientation {
    private enum MemberAccessName: String {
        case portrait, portraitUpsideDown, landscapeRight, landscapeLeft

        init(memberAccess: MemberAccessExprSyntax, context: SyntaxParserContext) throws {
            if let value = MemberAccessName(rawValue: memberAccess.name.text) {
                self = value
            } else {
                throw context.error("'\(memberAccess.name.text)' is not a supported InterfaceOrientation member")
            }
        }
    }
}
