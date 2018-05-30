//
//  ConnectionViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionViewController: UIViewController, ConnectionDelegate, ReceiverDelegate {

    @IBOutlet weak var testingLabel: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var avatar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MPHelper.shared.connectionDelegate = self
        MPHelper.shared.receiverDelegate = self
        MPHelper.shared.startAdvertesing()
    }
    func didBeginConnection(to peerID: MCPeerID) {
        self.testingLabel.text = "Found connection"
    }
    
    func isConnecting(to peerID: MCPeerID) {
        self.testingLabel.text = "Is connecting"
    }
    
    func didEstablishConnection(with peerID: MCPeerID) {
        self.testingLabel.text = "Did estabilish connection"
    }
    
    func didLostConnection(with peerID: MCPeerID) {
        self.testingLabel.text = "Connection lost"
    }
    
    var peerFound: MCPeerID!
    
    func receive(data: Data, from peer: MCPeerID) {
        do {
            let playerStruct = try JSONDecoder().decode(PlayerStruct.self, from: data)
            self.name.text = playerStruct.name
            self.avatar.text = playerStruct.avatar.rawValue
            self.peerFound = peer
        } catch { }
    }
    
    @IBAction func didClickWaitingScreen(_ sender: Any) {
        let waitEveryone = DisplayScreen.init(screen: .waiting)
        do {
            let data = try JSONEncoder().encode(waitEveryone)
            MPHelper.shared.send(data: data, dataMode: .reliable, for: [self.peerFound])
        } catch {}
    }
    
    func receive(error: Error) { }
}
