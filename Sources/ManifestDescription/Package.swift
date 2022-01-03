import Foundation

public struct Package: Equatable, Codable {
    /// The name of the package as it appears in the manifest
    public var name: String

    /// The default localization for resources.
    public var defaultLocalization: String?

    /// The declared platforms in the manifest.
    public var platforms: [Platform]?

    /// The pkg-config name of a system package.
    public var pkgConfig: String?

//    /// The system package providers of a system package.
//    public let providers: [SystemPackageProviderDescription]?

    /// The products declared in the manifest.
    public var products: [Product]

    /// The declared package dependencies.
    public let dependencies: [Dependency]

    /// The targets declared in the manifest.
    public let targets: [Target]

//    /// The supported Swift language versions of the package.
//    public let swiftLanguageVersions: [SwiftLanguageVersion]?

    /// The C language standard flag.
    public var cLanguageStandard: String?

    /// The C++ language standard flag.
    public var cxxLanguageStandard: String?

    public init(
        name: String,
        defaultLocalization: String? = nil,
        platforms: [Platform]? = nil,
        pkgConfig: String? = nil,
//        providers: [SystemPackageProviderDescription]? = nil,,
        products: [Product] = [],
        dependencies: [Dependency] = [],
        targets: [Target] = [],
//        swiftLanguageVersions: [SwiftLanguageVersion]? = nil,
        cLanguageStandard: String? = nil,
        cxxLanguageStandard: String? = nil
    ) {
        self.name = name
        self.defaultLocalization = defaultLocalization
        self.platforms = platforms
        self.pkgConfig = pkgConfig
//        self.providers = providers
        self.products = products
        self.dependencies = dependencies
        self.targets = targets
//        self.swiftLanguageVersions = swiftLanguageVersions
        self.cLanguageStandard = cLanguageStandard
        self.cxxLanguageStandard = cxxLanguageStandard
    }
}
