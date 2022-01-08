import Foundation

protocol ContentProviding {
    associatedtype Content

    init(content: Content)
}
