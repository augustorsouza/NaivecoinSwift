import Vapor

final class BlockController {
    func index(_ req: Request) -> [Block] {
        return Blockchain.shared.blocks
    }

    func mine(_ req: Request) throws -> Future<Block> {
        var content: Future<[String: String]>

        do {
            content = try req.content.decode([String: String].self)
        } catch {
            throw Abort(.badRequest)
        }

        return content.map({ json in
            guard let data = json["data"] else {
                throw Abort(.badRequest)
            }
            return try Blockchain.shared.generateNextBlock(data: data)
        })

    }
}
