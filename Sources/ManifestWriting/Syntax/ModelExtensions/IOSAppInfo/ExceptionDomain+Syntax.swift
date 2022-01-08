import Foundation
import ManifestDescription
import SwiftSyntax

extension ProductSetting.IOSAppInfo.AppTransportSecurityConfiguration.ExceptionDomain: FunctionCallSyntaxRepresentable {
    var calledExpression: FunctionCalledExpression {
        .memberAccess(name: "init")
    }

    var arguments: [FunctionCallArgument] {
        var arguments: [FunctionCallArgument] = [
            FunctionCallArgument(label: "domainName", expression: StringLiteral(content: domainName))
        ]

        if let includesSubdomains = includesSubdomains {
            arguments.append(FunctionCallArgument(
                label: "includesSubdomains",
                expression: BooleanLiteral(content: includesSubdomains)
            ))
        }

        if let exceptionAllowsInsecureHTTPLoads = exceptionAllowsInsecureHTTPLoads {
            arguments.append(FunctionCallArgument(
                label: "exceptionAllowsInsecureHTTPLoads",
                expression: BooleanLiteral(content: exceptionAllowsInsecureHTTPLoads)
            ))
        }

        if let exceptionMinimumTLSVersion = exceptionMinimumTLSVersion {
            arguments.append(FunctionCallArgument(
                label: "exceptionMinimumTLSVersion",
                expression: StringLiteral(content: exceptionMinimumTLSVersion)
            ))
        }

        if let exceptionRequiresForwardSecrecy = exceptionRequiresForwardSecrecy {
            arguments.append(FunctionCallArgument(
                label: "exceptionRequiresForwardSecrecy",
                expression: BooleanLiteral(content: exceptionRequiresForwardSecrecy)
            ))
        }

        if let requiresCertificateTransparency = requiresCertificateTransparency {
            arguments.append(FunctionCallArgument(
                label: "requiresCertificateTransparency",
                expression: BooleanLiteral(content: requiresCertificateTransparency)
            ))
        }


        return arguments
    }
}
