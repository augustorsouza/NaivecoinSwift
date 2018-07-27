import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let blockController = BlockController()
    router.get("blocks", use: blockController.index)
    router.post("mineBlock", use: blockController.mine)

    let peerController = PeerController()
    router.get("peers", use: peerController.index)
    router.post("addPeer", use: peerController.add)
}
