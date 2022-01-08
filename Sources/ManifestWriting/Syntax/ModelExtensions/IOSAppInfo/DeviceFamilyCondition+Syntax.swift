import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.DeviceFamilyCondition: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: "when")
    }

    var arguments: [FunctionCallArgument] {
        [
            FunctionCallArgument(label: "deviceFamilies", expression: ArrayLiteral(content: deviceFamilies))
        ]
    }
}
