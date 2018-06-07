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
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var ringView: UIView!
    
    var audioPlayer = AVAudioPlayer()
    
    var currentState: State!
    
    var currentPlayer: Player!
    
    var battle: Battle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MPHelper.shared.receiverDelegate = self
        
        self.currentState = StartBattleState(viewController: self)
        if let willEnterState = self.currentState.willEnterState { willEnterState() }
        
        self.playSong()
        
    }
    
    func playSong(){
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "beat01-tvOS", ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: sound)
                audioPlayer.prepareToPlay()
            }catch{
                print("problem in playing music")
        }
        audioPlayer.play()
        audioPlayer.volume = 0.5
        audioPlayer.numberOfLoops = 3
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



