import Foundation
import Crypto

final class Blockchain {
    static let shared = Blockchain()

    private init() { }

    private(set) var blocks = [Block.genesis]

    func calculateHash(index: UInt, previousHash: String, data: String, timestamp: Date) throws -> String {
        var calculatedHash: String

        do {
            calculatedHash = try SHA256.hash("\(index) \(previousHash) \(timestamp) \(data)").hexEncodedString().lowercased()
        } catch {
            print("Failed to serialize and hash \(self) with error \(error)")
            throw error
        }

        return calculatedHash
    }

    func generateNextBlock(data: String) throws -> Block {
        let previousBlock = blocks.last!
        let nextIndex = previousBlock.index + 1
        let nextTimestamp = Date()

        do {
            let nextHash = try calculateHash(index: nextIndex, previousHash: previousBlock.hash, data: data, timestamp: nextTimestamp)

            let block = Block(index: nextIndex, hash: nextHash, previousHash: previousBlock.hash, data: data, timestamp: nextTimestamp)

            blocks.append(block)

            return block
        } catch {
            throw error
        }
    }

    func isBlockValid(block: Block, previousBlock: Block) -> Bool {
        let chain: [BlockValidator] = [IndexBlockValidator(), PreviousHashBlockValidator(), HashIntegrityBlockValidator()]

        for validator in chain {
            if validator.isValid(block: block, previousBlock: previousBlock) == false {
                return false
            }
        }

        return true
    }

    func isChainValid(blocks: [Block]) -> Bool {
        // Validate genesis block
        guard let firstBlock = blocks.first, firstBlock == Block.genesis else { return false }

        for (index, block) in blocks.enumerated() where index > 0 {
            let previouBlock = blocks[index - 1]
            let validation = isBlockValid(block: block, previousBlock: previouBlock)
            if validation == false {
                return false
            }
        }

        return true
    }

    func replaceChain(newBlocks: [Block]) {
        if isChainValid(blocks: newBlocks) && newBlocks.count > blocks.count {
            blocks = newBlocks
            // broadcastLatest()
        }
    }
}
