import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration.PinnedDomain: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            return Self.init(
                domainName: try processor.take("domainName", as: String.self),
                includesSubdomains: try processor.takeIfDefined("includesSubdomains", as: Bool?.self) ?? nil,
                pinnedCAIdentities: try processor.takeIfDefined("pinnedCAIdentities", as: [[String : String]]?.self) ?? nil,
                pinnedLeafIdentities: try processor.takeIfDefined("pinnedLeafIdentities", as: [[String : String]]?.self) ?? nil
            )
        }
    }
}
