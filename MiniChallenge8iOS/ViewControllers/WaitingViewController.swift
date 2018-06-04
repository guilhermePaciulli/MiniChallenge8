//
//  WaitingViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class WaitingViewController: UIViewController {
    
    @IBOutlet weak var waitingLabel: UILabel!
    
    var control: Int = 0
    
    var inputTextWaitingLabel = "aguardando"
    
    var isConnected = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.control = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            
            switch self.control{
            case 0:
                self.waitingLabel.text = self.inputTextWaitingLabel
                self.control += 1
            case 1:
                self.waitingLabel.text = "\(self.inputTextWaitingLabel) ."
                self.control += 1
            case 2:
                self.waitingLabel.text = "\(self.inputTextWaitingLabel) . ."
                self.control += 1
            case 3:
                self.waitingLabel.text = "\(self.inputTextWaitingLabel) . . ."
                self.control = 0
            default:
                break
            }
        }
        self.waitingLabel.textColor = UIColor.init(red: 1, green: 214/255, blue: 81/255, alpha: 1)
        var inputTextWaitingLabel = "aguardando"

        self.isConnected = MPHelper.shared.session == nil
        self.multipeerSetUp()
    }
    
    func multipeerSetUp() {
        if self.isConnected {
        } else {
            self.setUpConnection()
        }
    }
    
    func setUpConnection() {
        MPHelper.shared.connectionDelegate = self
        MPHelper.shared.receiverDelegate = self
        MPHelper.shared.startBrowsing()
    }
    
}

extension WaitingViewController: ConnectionDelegate, ReceiverDelegate {
    
    func didBeginConnection(to peerID: MCPeerID) {
        if self.isConnected {
            self.inputTextWaitingLabel = "conectando"
            self.waitingLabel.textColor = UIColor.init(red: 1, green: 214/255, blue: 81/255, alpha: 1)
        }
    }
    
    func didEstablishConnection(with peerID: MCPeerID) {
        if self.isConnected {
            self.inputTextWaitingLabel = "conectado!"
            self.waitingLabel.textColor = UIColor.init(red: 151/255, green: 237/255, blue: 181/255, alpha: 1)
        }
    }
    
    func didLostConnection(with peerID: MCPeerID) {
        if self.isConnected {
            self.inputTextWaitingLabel = "aguardando"
            self.waitingLabel.textColor = UIColor.init(red: 1, green: 214/255, blue: 81/255, alpha: 1)
        }
    }
    
    func receive(data: Data, from peer: MCPeerID) {
        if let screenToBeDisplayed = try? JSONDecoder().decode(DisplayScreen.self, from: data) {
            switch screenToBeDisplayed.screen {
            case .characterEditing:
                if let chooseCharacterViewController = self.storyboard?.instantiateViewController(withIdentifier: "chooseCharacterViewController") {
                    self.present(chooseCharacterViewController, animated: true, completion: nil)
                }
            case .waiting:
                break
            }
        }
    }
    
    func isConnecting(to peerID: MCPeerID) {}

    func receive(error: Error) { }
    
}
