import Foundation
import ManifestDescription

public protocol ManifestLoader {
    func load(from data: Data) throws -> Manifest
}

public extension ManifestLoader {
    func load(at fileURL: URL) throws -> Manifest {
        try load(from: try Data(contentsOf: fileURL))
    }

    func load(from fileWrapper: FileWrapper) throws -> Manifest {
        guard fileWrapper.isRegularFile else { throw StringError("FileWrapper must represent a regular file") }
        guard let data = fileWrapper.regularFileContents else { throw StringError("FileWrapper had no file contents") }
        return try load(from: data)
    }
}
