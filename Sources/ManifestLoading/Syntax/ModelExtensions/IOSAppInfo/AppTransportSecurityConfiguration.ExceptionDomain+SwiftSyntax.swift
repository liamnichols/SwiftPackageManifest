import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration.ExceptionDomain: ExpressibleByFunctionCallExprSyntax, TransformableFromExprSyntax {
    init(functionCall: FunctionCallExprSyntax, context: SyntaxParserContext) throws {
        self = try SyntaxArgumentProcessor.process(argumentList: functionCall.argumentList, in: context) { processor in
            return Self.init(
                domainName: try processor.take("domainName", as: String.self),
                includesSubdomains: try processor.takeIfDefined("includesSubdomains", as: Bool?.self) ?? nil,
                exceptionAllowsInsecureHTTPLoads: try processor.takeIfDefined("exceptionAllowsInsecureHTTPLoads", as: Bool?.self) ?? nil,
                exceptionMinimumTLSVersion: try processor.takeIfDefined("exceptionMinimumTLSVersion", as: String?.self) ?? nil,
                exceptionRequiresForwardSecrecy: try processor.takeIfDefined("exceptionRequiresForwardSecrecy", as: Bool?.self) ?? nil,
                requiresCertificateTransparency: try processor.takeIfDefined("requiresCertificateTransparency", as: Bool?.self) ?? nil
            )
        }
    }
}
