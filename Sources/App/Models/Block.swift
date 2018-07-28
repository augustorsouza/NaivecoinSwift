import Vapor
import Crypto

struct Block: Codable, Equatable {
    static let genesis: Block = Block(index: 0, hash: "816534932c2b7154836da6afc367695e6337db8a921823784c14378abed4f7d7", previousHash: "", data: "Genesis Block", timestamp: Date(timeIntervalSince1970: 0))

    let index: UInt
    let hash: String
    let previousHash: String
    let data: String
    let timestamp: Date

    static func ==(lhs: Block, rhs: Block) -> Bool {
        guard let lhsEncoded = try? JSONEncoder().encode(lhs),
            let rhsEncoded = try? JSONEncoder().encode(rhs)
            else { return false }
        return lhsEncoded == rhsEncoded
    }
}

/// Allows `Block` to be encoded to and decoded from HTTP messages.
extension Block: Content { }
