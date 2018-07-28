import Foundation
import Vapor

final class PeerManager {
    static let shared = PeerManager()

    private init() { }

    private(set) var peers: [Peer] = []

    private var websocketClients: [WebSocket] = []

    func setupWebsocketServer() -> NIOWebSocketServer {
        // Create a new NIO websocket server
        let wss = NIOWebSocketServer.default()

        // Add WebSocket upgrade support to GET /connect
        wss.get("connect") { ws, req in
            print("Added peer!")
            PeerManager.shared.websocketClients.append(ws)
        }

        return wss
    }

    func append(peer: Peer) {
        do {
            try setupP2PConnection(to: peer)
            peers.append(peer)
        } catch {
            fatalError("Could not connet to \(peer)")
        }
    }

    func broadcast(_ block: Block) {
        websocketClients.forEach { (ws) in
            do {
                let blockData = try JSONEncoder().encode(block)
                let blockString = String(data: blockData, encoding: .utf8) ?? ""
                ws.send(text: blockString)
            } catch {
                print("Failed to sendo block data for block \(block)")
            }
        }
    }

    private func setupP2PConnection(to peer: Peer) throws {
        let connectEndpoint = peer.address + "connect"

        _ = try application.client().webSocket(connectEndpoint).flatMap { ws -> Future<Void> in

            ws.onText({ (ws, text) in
                guard let blockData = text.data(using: .utf8), let block = try? JSONDecoder().decode(Block.self, from: blockData) else {
                    print(text)
                    return
                }

                var blocks = Blockchain.shared.blocks
                blocks.append(block)

                Blockchain.shared.replaceChain(newBlocks: blocks)
            })

            ws.send("Initiating a connection from \(application.environment.arguments.last ?? "")")

            return ws.onClose
        }
    }
}
