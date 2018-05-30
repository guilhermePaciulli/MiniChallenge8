//
//  ConnectionViewController.swift
//  MiniChallenge8iOS
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionViewController: UIViewController, ConnectionDelegate {

    @IBOutlet weak var testingLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MPHelper.shared.startBrowsing()
        MPHelper.shared.connectionDelegate = self
        
        self.sendButton.isHidden = true
        self.sendButton.isEnabled = false
    }

    func didBeginConnection(to peerID: MCPeerID) {
        self.testingLabel.text = "Found connection"
        self.sendButton.isHidden = false
    }
    
    func isConnecting(to peerID: MCPeerID) {
        self.testingLabel.text = "Is connecting"
    }
    
    func didEstablishConnection(with peerID: MCPeerID) {
        self.testingLabel.text = "Did estabilish connection"
        self.sendButton.isEnabled = true
    }
    
    func didLostConnection(with peerID: MCPeerID) {
        self.testingLabel.text = "Connection lost"
        self.sendButton.isHidden = true
        self.sendButton.isEnabled = false
    }

    @IBAction func didPressSendButton(_ sender: Any) {
        let datum = "Capivaras sao demais".data(using: .utf8)!
        MPHelper.shared.send(data: datum, dataMode: .reliable)
    }
}
