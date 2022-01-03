import Foundation

public struct Manifest: Equatable, Codable {
    /// The standard filename for the manifest.
    public static let filename = basename + ".swift"

    /// The standard basename for the manifest.
    public static let basename = "Package"
    
    /// The tools version declared in the manifest.
    public var toolsVersion: ToolsVersion

    /// The Package description defined in the manifest.
    public var package: Package

    public init(toolsVersion: ToolsVersion, package: Package) {
        self.toolsVersion = toolsVersion
        self.package = package
    }
}
