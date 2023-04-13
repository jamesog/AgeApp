import Foundation

struct Key: Codable, Hashable {
    /// A human-readable name for the key.
    var name: String
    /// The Bech32-encoded secret key.
    var key: String
    var createdDate: Date
}

extension Key: Comparable {
    static func < (lhs: Key, rhs: Key) -> Bool {
        lhs.name < rhs.name
    }
}
