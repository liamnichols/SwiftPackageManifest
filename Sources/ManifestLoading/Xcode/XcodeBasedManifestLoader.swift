import Foundation
import ManifestDescription

/// A `ManifestLoading` implementation that works by compiling the Package.swift file using build tools that are only available on macOS.
@available(iOS, unavailable)
public class XcodeBasedManifestLoader: ManifestLoader {
    public init() {

    }
    
    public func load(from data: Data) throws -> Manifest {
        fatalError("XcodeBasedManifestLoader has not yet been implemented.")
    }
}
