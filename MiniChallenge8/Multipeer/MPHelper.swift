//
//  MPHelper.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
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
    
    var session: MCSession?
    
    var peerId: MCPeerID?
    
    private let serviceType = "rapbattleinv853"
    
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    
    private let maxNumberOfConnections = 5
    
    override init() {
        super.init()
        self.prepare(name: "rapbattleadver")
    }
    
    func prepare(name: String) {
        self.peerId = MCPeerID(displayName: name)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerId!, discoveryInfo: nil, serviceType: self.serviceType)
        self.serviceAdvertiser.delegate = self
        self.createSession()
    }
    
    func send(data: Data, dataMode: MCSessionSendDataMode) {
        guard let session = self.session else{return}
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: dataMode)
            } catch let error {
                DispatchQueue.main.async {
                    self.receiverDelegate?.receive(error: error)
                }
            }
        }
    }
    
    func send(data: Data, dataMode: MCSessionSendDataMode, for peers: [MCPeerID]) {
        guard let session = self.session else { return }
        do {
            try session.send(data, toPeers: peers, with: dataMode)
        } catch let error {
            DispatchQueue.main.async {
                self.receiverDelegate?.receive(error: error)
            }
        }
    }
    
    func startAdvertesing() {
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func leaveSession() {
        self.session?.disconnect()
    }
    
    private func createSession() {
        self.session = MCSession(peer: self.peerId!, securityIdentity: nil, encryptionPreference: .none)
        self.session?.delegate = self
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
}

extension MPHelper: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        DispatchQueue.main.async {
            self.receiverDelegate?.receive(error: error)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.connectionDelegate?.didBeginConnection(to: peerID)
        }
        invitationHandler(true, self.session)
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
        guard let e = error else { return }
        DispatchQueue.main.async {
            self.receiverDelegate?.receive(error: e)
        }
    }
    
}
