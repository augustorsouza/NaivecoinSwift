import Vapor

final class PeerController {
    func index(_ req: Request) throws -> [Peer] {
        return PeerManager.shared.peers
    }

    func add(_ req: Request) throws -> Future<String> {
        var content: Future<[String: String]>

        do {
            content = try req.content.decode([String: String].self)
        } catch {
            throw Abort(.badRequest)
        }

        return content.map({ json in
            guard let address = json["peer"] else {
                throw Abort(.badRequest)
            }
            PeerManager.shared.append(peer: Peer(address: address))
            return "Ok"
        })
    }
}
