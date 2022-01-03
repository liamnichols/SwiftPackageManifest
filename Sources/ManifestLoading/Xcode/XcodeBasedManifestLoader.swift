import Foundation
import ManifestDescription

/// A `ManifestLoading` implementation that works by compiling the Package.swift file using build tools that are only available on macOS.
@available(iOS, unavailable)
public class CompiledManifestLoader: ManifestLoader {
    public init() {

    }
    
    public func load(at fileURL: URL) throws -> Manifest {
        fatalError("CompiledManifestLoader has not yet been implemented.")
    }
}
