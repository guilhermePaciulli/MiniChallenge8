//
//  ConnectionViewController.swift
//  MiniChallenge8iOS
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionViewController: UIViewController, ConnectionDelegate, ReceiverDelegate {

    @IBOutlet weak var testingLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MPHelper.shared.connectionDelegate = self
        MPHelper.shared.receiverDelegate = self
        MPHelper.shared.startBrowsing()
        
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
        let playerStruct = PlayerStruct.init(name: "MC Capivara", avatar: .rabbit)
        do {
            let datum = try JSONEncoder().encode(playerStruct)
            MPHelper.shared.send(data: datum, dataMode: .reliable)
        } catch { }
    }
    
    func receive(data: Data, from peer: MCPeerID) {
        do {
            let changeScreen = try JSONDecoder().decode(DisplayScreen.self, from: data)
            if changeScreen.screen == .waiting {
                let alert = UIAlertController.init(title: "Wating", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
                self.present(alert, animated: true, completion: {})
            }
        } catch { }
    }
    
    func receive(error: Error) { }
}
