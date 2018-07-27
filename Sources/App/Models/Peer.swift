import Vapor

struct Peer: Codable, Hashable {
    let address: String
}

/// Allows `Peer` to be encoded to and decoded from HTTP messages.
extension Peer: Content { }
