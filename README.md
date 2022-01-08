# Swift Package Manifest

A set of libraries used for parsing representations of Swift Packages similar to how SwiftPM itself works, but also supporting Xcode specific features (such as Swift Playground Apps).

As part of this package, there are two libraries:

- **ManifestDescription** - Models used to represent the contents of a SPM Manifest.
- **ManifestLoading** - Classes capable of loading `Manifest` representations from **Package.swift** source files.
- **ManifestWriting** - Capable of writing out a **Package.swift** file based on a `Manifest` representation.

## ManifestLoading

The ManifestLoading library exposes a simple `ManifestLoader` protocol with two concrete implementations provided:

`SyntaxBasedManifestLoader`|`XcodeBasedManifestLoader`*
---|---
Loads simple manifest files by walking though the Swift AST provided by [SwiftSyntax](https://github.com/apple/swift-syntax). Won't work with anything other than literal values defined in the `Package` initializer expression, but can be used on iOS.|Compiles the **Package.swift** and evaluates the JSON output exactly like Swift Package Manager does. This is much more reliable, but requires macOS.<br/><br/>_* Not yet implemented_
