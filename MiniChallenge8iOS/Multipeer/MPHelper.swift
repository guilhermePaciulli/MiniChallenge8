//
//  MPHelper.swift
//  MiniChallenge8iOS
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ReceiverDelegate {
    func receive(data: Data, from peer: MCPeerID)
    func receive(error: Error)
}

protocol ConnectionDelegate {
    func didBeginConnection(to peerID: MCPeerID)
    func isConnecting(to peerID: MCPeerID)
    func didEstablishConnection(with peerID: MCPeerID)
    func didLostConnection(with peerID: MCPeerID)
}

class MPHelper: NSObject {
    
    static let shared = MPHelper()
    
    var receiverDelegate: ReceiverDelegate?
    
    var connectionDelegate: ConnectionDelegate?
    
    var session : MCSession?
    
    var peerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceType = "rapbattleinv853"
    
    private let validAdvertiser = "rapbattleadver"
    
    private var serviceBrowser: MCNearbyServiceBrowser!
    
    override init() {
        super.init()
        self.prepare()
    }
    
    func prepare() {
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.peerId, serviceType: self.serviceType)
        self.serviceBrowser.delegate = self
        self.createSession()
    }
    
    func send(data: Data, dataMode: MCSessionSendDataMode) {
        guard let session = self.session else { return }
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: dataMode)
            } catch let error {
                receiverDelegate?.receive(error: error)
            }
        }
    }
    func startBrowsing(){
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing(){
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func joinSession(session id: MCPeerID){
        guard let session = self.session else { return }
        self.serviceBrowser.invitePeer(id, to: session, withContext: nil, timeout: 180)
    }
    
    func leaveSession() {
        session?.disconnect()
    }
    
    private func createSession() {
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
    }
    
    deinit {
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
}

extension MPHelper: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.receiverDelegate?.receive(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if peerID.displayName == self.validAdvertiser {
            self.joinSession(session: peerID)
            DispatchQueue.main.async {
                self.connectionDelegate?.didBeginConnection(to: peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
}

extension MPHelper: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.connectionDelegate?.didEstablishConnection(with: peerID)
            case .connecting:
                self.connectionDelegate?.isConnecting(to: peerID)
            case .notConnected:
                self.connectionDelegate?.didLostConnection(with: peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.receiverDelegate?.receive(data: data, from: peerID)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard let e = error else {return}
        receiverDelegate?.receive(error: e)
    }
    
}
