import Foundation
import ManifestDescription

public protocol ManifestLoader {
    func load(at fileURL: URL) throws -> Manifest
}
