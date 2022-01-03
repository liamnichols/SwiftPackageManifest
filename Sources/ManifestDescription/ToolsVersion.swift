// https://github.com/apple/swift-package-manager/blob/af43c15d900d96615afe5fd502f949026cfb8714/Sources/PackageModel/ToolsVersion.swift

/*
 This source file is part of the Swift.org open source project
 Copyright (c) 2014 - 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception
 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import Foundation

/// Tools version represents version of the Swift toolchain.
public struct ToolsVersion: Equatable, Hashable, Codable {

    public static let v3 = ToolsVersion(version: "3.1.0")
    public static let v4 = ToolsVersion(version: "4.0.0")
    public static let v4_2 = ToolsVersion(version: "4.2.0")
    public static let v5 = ToolsVersion(version: "5.0.0")
    public static let v5_2 = ToolsVersion(version: "5.2.0")
    public static let v5_3 = ToolsVersion(version: "5.3.0")
    public static let v5_4 = ToolsVersion(version: "5.4.0")
    public static let v5_5 = ToolsVersion(version: "5.5.0")
    public static let v5_6 = ToolsVersion(version: "5.6.0")
    public static let vNext = ToolsVersion(version: "999.0.0")

    /// Regex pattern to parse tools version. The format is SemVer 2.0 with an
    /// addition that specifying the patch version is optional.
    static let toolsVersionRegex = try! NSRegularExpression(
        pattern: #"""
                 ^
                 (\d+)\.(\d+)(?:\.(\d+))?
                 (
                     \-[A-Za-z\d]+(?:\.[A-Za-z\d]+)*
                 )?
                 (
                     \+[A-Za-z\d]+(?:\.[A-Za-z\d]+)*
                 )?
                 $
                 """#,
        options: [.allowCommentsAndWhitespace]
    )

    /// The major version number.
    public var major: Int {
        return _version.major
    }

    /// The minor version number.
    public var minor: Int {
        return _version.minor
    }

    /// The patch version number.
    public var patch: Int {
        return _version.patch
    }

    /// Returns the tools version with zeroed patch number.
    public var zeroedPatch: ToolsVersion {
        return ToolsVersion(version: Version(major, minor, 0))
    }

    /// The underlying backing store.
    fileprivate let _version: Version

    /// Create an instance of tools version from a given string.
    public init?(string: String) {
        guard let match = ToolsVersion.toolsVersionRegex.firstMatch(
            in: string, options: [], range: NSRange(location: 0, length: string.count)) else {
            return nil
        }
        // The regex succeeded, compute individual components.
        assert(match.numberOfRanges == 6)
        let string = NSString(string: string)
        let major = Int(string.substring(with: match.range(at: 1)))!
        let minor = Int(string.substring(with: match.range(at: 2)))!
        let patchRange = match.range(at: 3)
        let patch = patchRange.location != NSNotFound ? Int(string.substring(with: patchRange))! : 0
        // We ignore storing pre-release and build identifiers for now.
        _version = Version(major, minor, patch)
    }

    /// Create instance of tools version from a given version.
    ///
    /// - precondition: prereleaseIdentifiers and buildMetadataIdentifier should not be present.
    public init(version: Version) {
        _version = version
    }
}

extension ToolsVersion: CustomStringConvertible {
    public var description: String {
        return _version.description
    }
}

extension ToolsVersion: Comparable {
    public static func < (lhs: ToolsVersion, rhs: ToolsVersion) -> Bool {
        return lhs._version < rhs._version
    }
}
