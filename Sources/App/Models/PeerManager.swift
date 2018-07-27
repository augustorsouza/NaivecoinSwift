import Foundation
import Vapor

final class PeerManager {
    static let shared = PeerManager()

    private init() { }

    private(set) var peers: [Peer] = []
    private(set) var webSockets: [Future<Void>] = []

    func append(peer: Peer) {
        do {
            let done = try application.client().webSocket(peer.address).flatMap { ws -> Future<Void> in
                // setup an on text callback that will print the echo
                ws.onText { ws, text in
                    print("rec: \(text)")
                    // close the websocket connection after we recv the echo
                    ws.close()
                }

                // when the websocket first connects, send message
                ws.send("hello, world!")

                // return a future that will complete when the websocket closes
                return ws.onClose
            }
            
            peers.append(peer)
            webSockets.append(done)
        } catch {
            fatalError("Could not connet to \(peer)")
        }
    }
}
