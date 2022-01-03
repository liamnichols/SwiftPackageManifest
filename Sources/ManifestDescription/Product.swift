import Foundation

public struct Product: Equatable, Codable {
    public enum ProductType: Equatable, Codable {
        /// A library product
        case library/*(LibraryType)*/

        /// A command line executable
        case executable

        /// An iOS application
        case iOSApplication

        // Not supported
        // case snippet, plugin, test
    }

    /// The name of the product.
    public var name: String

    /// The type of product to create.
    public var type: ProductType

    ///
    public var targets: [String]

    /// A series of settings to apply to a product. Some may be specific to certain platforms.
    public var settings: [ProductSetting]

    public init(name: String, type: ProductType, targets: [String], settings: [ProductSetting]) {
        self.name = name
        self.type = type
        self.targets = targets
        self.settings = settings
    }
}
