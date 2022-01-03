import Foundation

public enum Dependency: Equatable, Codable {
    public enum Requirement: Equatable, Hashable, Codable {
        case exact(Version)
        case range(Range<Version>)
        case revision(String)
        case branch(String)
    }

    // TODO: SPM's PackageDependencyDescription is a lot more complex than this. We might need to take some inspiration

    /// A local package dependency.
    case fileSystem(name: String?, path: String)

    public init(name: String? = nil, path: String) {
        self = .fileSystem(name: name, path: path)
    }

    /// A remote package dependency.
    case sourceControl(name: String?, url: URL, requirement: Requirement)

    public init(name: String? = nil, url: URL, requirement: Requirement) {
        self = .sourceControl(name: name, url: url, requirement: requirement)
    }
}
