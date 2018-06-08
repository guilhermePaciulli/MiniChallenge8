//
//  BattleGameViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class BattleGameViewController: UIViewController {
    
    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player1Avatar: UIImageView!
    @IBOutlet weak var player1PercentageLabel: UILabel!
    @IBOutlet weak var player1Bar: UIView!
    
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player2Avatar: UIImageView!
    @IBOutlet weak var player2PercentageLabel: UILabel!
    @IBOutlet weak var player2Bar: UIView!
    
    var barWidth: CGFloat!
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var ringView: UIView!

    @IBOutlet weak var currentStateLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!

    
    var audioPlayer = AVAudioPlayer()
    
    var currentState: State!
    
    var currentPlayer: Player!
    
    var playerAvatarOrigins: [MCPeerID: CGPoint]!
    
    var playerAvatarSizes: [MCPeerID: CGSize]!
        
    var battle: Battle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barWidth = self.player1Bar.frame.size.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MPHelper.shared.receiverDelegate = self
        
        self.playerAvatarOrigins = [self.battle.player1.peerID: self.player1Avatar.frame.origin,
                                    self.battle.player2.peerID: self.player2Avatar.frame.origin]
        
        self.playerAvatarSizes = [self.battle.player1.peerID: self.player1Avatar.frame.size,
                                  self.battle.player2.peerID: self.player2Avatar.frame.size]
        
        self.currentState = StartTurnState(viewController: self)
        if let willEnterState = self.currentState.willEnterState { willEnterState() }
        
        self.playSong()
        
    }
    
    func playSong(){
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "beat01-tvOS", ofType: "mp3")!)
            do{
                self.audioPlayer = try AVAudioPlayer(contentsOf: sound)
                self.audioPlayer.prepareToPlay()
            }catch{
                print("problem in playing music")
        }
        self.audioPlayer.play()
        self.audioPlayer.volume = 0.5
        self.audioPlayer.numberOfLoops = -1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let didEnterState = self.currentState.didEnterState {
            didEnterState()
        }
    }
    
    func moveTo(state: State) {
        if let didExitState = self.currentState.didExitState { didExitState() }
        self.currentState = state
        if let willEnterState = self.currentState.willEnterState { willEnterState() }
        if let didEnterState = self.currentState.didEnterState { didEnterState() }
    }

}

extension BattleGameViewController: ReceiverDelegate {
    
    func receive(data: Data, from peer: MCPeerID) {
        if let didReceiveData = self.currentState.didReceive { didReceiveData(data, peer) }
    }
    
    func receive(error: Error) {}
    
}

extension BattleGameViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag { if let animationDidStop = self.currentState.animationDidStop { animationDidStop(anim) } }
    }
    
}



