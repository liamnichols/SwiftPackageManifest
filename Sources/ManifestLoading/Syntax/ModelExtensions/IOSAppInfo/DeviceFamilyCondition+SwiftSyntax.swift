import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.DeviceFamilyCondition: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    private typealias DeviceFamility = ProductSetting.IOSAppInfo.DeviceFamily

    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        // Make sure this matches the 'when(deviceFaimily: ...)' expression we are expecting
        let memberAccess = try functionCall.memberAccess(context)
        guard memberAccess.name.text == "when" else {
            throw context.error("Expected 'when' condition but got '\(memberAccess.name.text)'")
        }

        // Parse the arguments
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            // Extract the required deviceFamilies array
            let deviceFamilies = try processor.take("deviceFamilies", as: [DeviceFamility].self)
            return .when(deviceFamilies: deviceFamilies)
        }
    }
}
