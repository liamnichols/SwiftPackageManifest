import Foundation

/// A particular setting to apply to a product. Some may be specific to certain platforms.
public enum ProductSetting: Equatable, Codable {
    /// An application bundle identifier.
    case bundleIdentifier(String)

    /// An identifier of a development team.
    case teamIdentifier(String)

    /// The display version of an app (marketing version).
    case displayVersion(String)

    /// The bundle version fo an app.
    case bundleVersion(String)

    /// Information about an iOS Application product.
    case iOSAppInfo(ProductSetting.IOSAppInfo)

    ///
    public struct IOSAppInfo: Equatable, Codable {
        /// Represents a family of device types that an application can support.
        public enum DeviceFamily: String, Equatable, Codable {
            case phone
            case pad
            case mac
        }

        /// Represents a condition on a particular device family.
        public struct DeviceFamilyCondition : Equatable, Codable {
            public var deviceFamilies: [DeviceFamily]

            public init(deviceFamilies: [DeviceFamily]) {
                self.deviceFamilies = deviceFamilies
            }

            public static func when(deviceFamilies: [DeviceFamily]) -> DeviceFamilyCondition {
                .init(deviceFamilies: deviceFamilies)
            }
        }

        /// Represents a supported device interface orientation.
        public enum InterfaceOrientation: Equatable, Codable {
            public enum Label: String {
                case portrait, portraitUpsideDown, landscapeRight, landscapeLeft
            }

            public static var portrait: InterfaceOrientation { .portrait() }
            case portrait(DeviceFamilyCondition? = nil)

            public static var portraitUpsideDown: InterfaceOrientation { .portraitUpsideDown() }
            case portraitUpsideDown(DeviceFamilyCondition? = nil)

            public static var landscapeRight: InterfaceOrientation { .landscapeRight() }
            case landscapeRight(DeviceFamilyCondition? = nil)

            public static var landscapeLeft: InterfaceOrientation { .landscapeLeft() }
            case landscapeLeft(DeviceFamilyCondition? = nil)

            public var label: Label {
                switch self {
                case .portrait:
                    return .portrait
                case .portraitUpsideDown:
                    return .portraitUpsideDown
                case .landscapeRight:
                    return .landscapeRight
                case .landscapeLeft:
                    return .landscapeLeft
                }
            }

            public var condition: DeviceFamilyCondition? {
                switch self {
                case .portrait(let condition),
                     .portraitUpsideDown(let condition),
                     .landscapeRight(let condition),
                     .landscapeLeft(let condition):
                    return condition
                }
            }
        }

        /// A capability required by the device.
        public enum Capability: Equatable, Codable {
            case appTransportSecurity(configuration: AppTransportSecurityConfiguration, DeviceFamilyCondition? = nil)

            case bluetoothAlways(purposeString: String, DeviceFamilyCondition? = nil)

            case calendars(purposeString: String, DeviceFamilyCondition? = nil)

            case camera(purposeString: String, DeviceFamilyCondition? = nil)

            case contacts(purposeString: String, DeviceFamilyCondition? = nil)

            case faceID(purposeString: String, DeviceFamilyCondition? = nil)

            case localNetwork(purposeString: String, bonjourServiceTypes: [String]? = nil, DeviceFamilyCondition? = nil)

            case locationAlwaysAndWhenInUse(purposeString: String, DeviceFamilyCondition? = nil)

            case locationWhenInUse(purposeString: String, DeviceFamilyCondition? = nil)

            case mediaLibrary(purposeString: String, DeviceFamilyCondition? = nil)

            case microphone(purposeString: String, DeviceFamilyCondition? = nil)

            case motion(purposeString: String, DeviceFamilyCondition? = nil)

            case nearbyInteractionAllowOnce(purposeString: String, DeviceFamilyCondition? = nil)

            case photoLibrary(purposeString: String, DeviceFamilyCondition? = nil)

            case photoLibraryAdd(purposeString: String, DeviceFamilyCondition? = nil)

            case reminders(purposeString: String, DeviceFamilyCondition? = nil)

            case speechRecognition(purposeString: String, DeviceFamilyCondition? = nil)

            case userTracking(purposeString: String, DeviceFamilyCondition? = nil)
        }

        public struct AppTransportSecurityConfiguration: Equatable, Codable {
            public var allowsArbitraryLoadsInWebContent: Bool?

            public var allowsArbitraryLoadsForMedia: Bool?

            public var allowsLocalNetworking: Bool?

            public var exceptionDomains: [AppTransportSecurityConfiguration.ExceptionDomain]?

            public var pinnedDomains: [AppTransportSecurityConfiguration.PinnedDomain]?

            public struct ExceptionDomain: Equatable, Codable {
                public var domainName: String

                public var includesSubdomains: Bool?

                public var exceptionAllowsInsecureHTTPLoads: Bool?

                public var exceptionMinimumTLSVersion: String?

                public var exceptionRequiresForwardSecrecy: Bool?

                public var requiresCertificateTransparency: Bool?

                public init(
                    domainName: String,
                    includesSubdomains: Bool? = nil,
                    exceptionAllowsInsecureHTTPLoads: Bool? = nil,
                    exceptionMinimumTLSVersion: String? = nil,
                    exceptionRequiresForwardSecrecy: Bool? = nil,
                    requiresCertificateTransparency: Bool? = nil
                ) {
                    self.domainName = domainName
                    self.includesSubdomains = includesSubdomains
                    self.exceptionAllowsInsecureHTTPLoads = exceptionAllowsInsecureHTTPLoads
                    self.exceptionMinimumTLSVersion = exceptionMinimumTLSVersion
                    self.exceptionRequiresForwardSecrecy = exceptionRequiresForwardSecrecy
                    self.requiresCertificateTransparency = requiresCertificateTransparency
                }
            }

            public struct PinnedDomain: Equatable, Codable {
                public var domainName: String

                public var includesSubdomains: Bool?

                public var pinnedCAIdentities: [[String : String]]?

                public var pinnedLeafIdentities: [[String : String]]?

                public init(
                    domainName: String,
                    includesSubdomains: Bool? = nil,
                    pinnedCAIdentities: [[String : String]]? = nil,
                    pinnedLeafIdentities: [[String : String]]? = nil
                ) {
                    self.domainName = domainName
                    self.includesSubdomains = includesSubdomains
                    self.pinnedCAIdentities = pinnedCAIdentities
                    self.pinnedLeafIdentities = pinnedLeafIdentities
                }
            }

            public init(
                allowsArbitraryLoadsInWebContent: Bool? = nil,
                allowsArbitraryLoadsForMedia: Bool? = nil,
                allowsLocalNetworking: Bool? = nil,
                exceptionDomains: [AppTransportSecurityConfiguration.ExceptionDomain]? = nil,
                pinnedDomains: [AppTransportSecurityConfiguration.PinnedDomain]? = nil
            ) {
                self.allowsArbitraryLoadsInWebContent = allowsArbitraryLoadsInWebContent
                self.allowsArbitraryLoadsForMedia = allowsArbitraryLoadsForMedia
                self.allowsLocalNetworking = allowsLocalNetworking
                self.exceptionDomains = exceptionDomains
                self.pinnedDomains = pinnedDomains
            }
        }

        public var iconAssetName: String?

        public var accentColorAssetName: String?

        public var supportedDeviceFamilies: [DeviceFamily]

        public var supportedInterfaceOrientations: [InterfaceOrientation]

        public var capabilities: [Capability]
        
        public var additionalInfoPlistContentFilePath: String?

        public init(
            iconAssetName: String?,
            accentColorAssetName: String?,
            supportedDeviceFamilies: [DeviceFamily],
            supportedInterfaceOrientations: [InterfaceOrientation],
            capabilities: [Capability],
            additionalInfoPlistContentFilePath: String? = nil
        ) {
            self.iconAssetName = iconAssetName
            self.accentColorAssetName = accentColorAssetName
            self.supportedDeviceFamilies = supportedDeviceFamilies
            self.supportedInterfaceOrientations = supportedInterfaceOrientations
            self.capabilities = capabilities
            self.additionalInfoPlistContentFilePath = additionalInfoPlistContentFilePath
        }
    }
}
