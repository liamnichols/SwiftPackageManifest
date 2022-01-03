import Foundation

public struct Target: Equatable, Codable {
    /// The target type.
    public enum TargetType: String, Equatable, Codable {
        case regular
        case executable
//        case test
//        case system
//        case binary
//        case plugin
    }

    /// Represents a target's dependency on another entity.
    public enum Dependency: Equatable, Codable {
        case target(name: String/*, condition: PackageConditionDescription?*/)
        case product(name: String, package: String/*, condition: PackageConditionDescription?*/)
        case byName(name: String/*, condition: PackageConditionDescription?*/)
    }

    /// The name of the target.
    public var name: String

    /// The type of target.
    public var type: TargetType

    /// The declared target dependencies.
    public var dependencies: [Dependency]

    /// The custom path of the target.
    public var path: String?

    // TODO: Support other types and more advanced configuration.

    public init(
        name: String,
        type: TargetType,
        dependencies: [Dependency],
        path: String?
    ) {
        self.name = name
        self.type = type
        self.dependencies = dependencies
        self.path = path
    }
}
