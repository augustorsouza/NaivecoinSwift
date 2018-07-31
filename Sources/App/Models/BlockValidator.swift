import Foundation

protocol BlockValidator {
    func isValid(block: Block, previousBlock: Block) -> Bool
}

struct IndexBlockValidator: BlockValidator {
    func isValid(block: Block, previousBlock: Block) -> Bool {
        return block.index - 1 == previousBlock.index
    }
}

struct PreviousHashBlockValidator: BlockValidator {
    func isValid(block: Block, previousBlock: Block) -> Bool {
        return block.previousHash == previousBlock.hash
    }
}

struct HashIntegrityBlockValidator: BlockValidator {
    func isValid(block: Block, previousBlock: Block) -> Bool {
        guard let calculatedHash = try? Blockchain.shared.calculateHash(index: block.index, previousHash: block.previousHash, data: block.data, timestamp: block.timestamp)
            else { return false }
        return calculatedHash == block.hash
    }
}
