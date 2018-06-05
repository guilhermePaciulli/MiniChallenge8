//
//  PreBattleViewController.swift
//  MiniChallenge8
//
//  Created by Bruno Cruz on 01/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PreBattleViewControllerTVOS: UIViewController {

    @IBOutlet weak var player1ImageView: UIImageView!
    @IBOutlet weak var player1Name: UILabel!
    
    @IBOutlet weak var player2ImageView: UIImageView!
    @IBOutlet weak var player2Name: UILabel!
    
    @IBOutlet weak var choosenLabel: UILabel!
    
    @IBOutlet weak var battleButton: UIButton!
    
    var currentBattle: Battle!
    
    var championship: Championship!
    
    var playerChosen: Player!
    var playerNotChosen: Player!
    
    var playerToStart: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let opponentStarterGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSelectOpponentStarter))
        opponentStarterGestureRecognizer.direction = .up
        let playerStarterGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSelectPlayerStarter))
        playerStarterGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(opponentStarterGestureRecognizer)
        self.view.addGestureRecognizer(playerStarterGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MPHelper.shared.receiverDelegate = self
        
        self.battleButton.isEnabled = false
        self.currentBattle = self.championship.nextBattle()
        
        let player1 = self.currentBattle.player1
        self.player1Name.text = player1.name
        self.player1ImageView.image = player1.avatar
        
        let player2 = self.currentBattle.player2
        self.player2Name.text = player2.name
        self.player2ImageView.image = player2.avatar
        
        var chosen = ""
        if Int(arc4random_uniform(100)) <= 50 {
            chosen = player1.name
            self.playerChosen = player1
            self.playerNotChosen = player2
        } else {
            chosen = player2.name
            self.playerChosen = player2
            self.playerNotChosen = player1
        }
        
        var append = "veja no seu iphone"
        if chosen == "mc t-vos" {
            append = "deslize para baixo para você começar ou para cima para seu oponente"
        }
        
        self.choosenLabel.text = "\(chosen) foi sorteado \(append)"
        
        if let displayScreenData = try? JSONEncoder().encode(DisplayScreen(screen: .chooseStarter)) {
            MPHelper.shared.send(data: displayScreenData, dataMode: .reliable, for: [self.playerChosen.peerID])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MPHelper.shared.receiverDelegate = nil
    }
    
    @IBAction func didPressBattleButton(_ sender: Any) {
        if let playerToStart = self.playerToStart {
            if let battleViewController = self.storyboard?.instantiateViewController(withIdentifier: "battleViewController") as? BattleGameViewController {
                battleViewController.currentPlayer = playerToStart
                battleViewController.battle = self.currentBattle
                self.present(battleViewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func didSelectOpponentStarter() {
        if self.playerChosen.name == "mc t-vos" && self.playerToStart == nil {
            self.didChose(starter: ChooseStarterStruct(starter: .opponent))
        }
    }
    
    @objc func didSelectPlayerStarter() {
        if self.playerChosen.name == "mc t-vos" && self.playerToStart == nil {
            self.didChose(starter: ChooseStarterStruct(starter: .player))
        }
    }
    
    func didChose(starter: ChooseStarterStruct) {
        if starter.starter == .player {
            self.playerToStart = self.playerChosen
        } else {
            self.playerToStart = self.playerNotChosen
        }
        self.choosenLabel.text = "Quem vai começar é o \(String(describing: self.playerToStart!.name)) aperte o botão do controle para continuar"
        self.battleButton.isEnabled = true
    }
    
}

extension PreBattleViewControllerTVOS: ReceiverDelegate {
    
    func receive(data: Data, from peer: MCPeerID) {
        if let starterStruct = try? JSONDecoder().decode(ChooseStarterStruct.self, from: data) {
            self.didChose(starter: starterStruct)
        }
    }
    
    func receive(error: Error) {}
    
}
