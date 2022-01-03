import Foundation

public struct Platform: Equatable, Codable {
    public struct Version: Equatable, Codable {
        public let value: String

        public init(value: String) {
            self.value = value
        }
    }

    public var name: String
    public var oldestSupportedVersion: Version

    public init(name: String, oldestSupportedVersion: Version) {
        self.name = name
        self.oldestSupportedVersion = oldestSupportedVersion
    }
}
