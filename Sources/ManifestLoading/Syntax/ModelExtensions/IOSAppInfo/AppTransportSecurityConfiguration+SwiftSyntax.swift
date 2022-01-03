import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    private typealias ExceptionDomain = ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration.ExceptionDomain
    private typealias PinnedDomain = ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration.PinnedDomain

    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            return Self.init(
                allowsArbitraryLoadsInWebContent: try processor.takeIfDefined("allowsArbitraryLoadsInWebContent", as: Bool?.self) ?? nil,
                allowsArbitraryLoadsForMedia: try processor.takeIfDefined("allowsArbitraryLoadsForMedia", as: Bool?.self) ?? nil,
                allowsLocalNetworking: try processor.takeIfDefined("allowsLocalNetworking", as: Bool?.self) ?? nil,
                exceptionDomains: try processor.takeIfDefined("exceptionDomains", as: [ExceptionDomain]?.self) ?? nil,
                pinnedDomains: try processor.takeIfDefined("pinnedDomains", as: [PinnedDomain]?.self) ?? nil
            )
        }
    }
}
