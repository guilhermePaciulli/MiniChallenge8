//
//  StartBattleState.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit

class StartTurnState: State {
    
    var viewController: BattleGameViewController
    
    var countdown = 4
    
    init(viewController: BattleGameViewController) {
        self.viewController = viewController
    }
    
    func willEnterState() {
        self.viewController.player1NameLabel.text = self.viewController.battle.player1.name
        self.viewController.player1Avatar.image = self.viewController.battle.player1.avatar
        
        self.viewController.player2NameLabel.text = self.viewController.battle.player2.name
        self.viewController.player2Avatar.image = self.viewController.battle.player2.avatar
        
        self.viewController.countdownLabel.isHidden = false
    } 
        
    func didEnterState() {
        if self.viewController.battle.rounds.count == 0 {
            self.viewController.battle.rounds.append(Round())
        }
        self.countdown = 4
        self.viewController.countdownLabel.text = "5"
        self.timerCountdown()
    }
    
    func timerCountdown() {
        if self.countdown == -1 {
            self.viewController.countdownLabel.text = "Valendo"
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.show(player: self.viewController.currentPlayer)
                self.viewController.countdownLabel.isHidden = true
            })
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.viewController.countdownLabel.text = "\(self.countdown)"
                self.countdown -= 1
                self.timerCountdown()
            })
        }
    }
    
    func show(player: Player) {
        var image: UIImageView!
        if self.viewController.battle.player1.peerID == player.peerID {
            image = self.viewController.player1Avatar
        } else {
            image = self.viewController.player2Avatar
        }
        UIView.animate(withDuration: 1, animations: {
            image?.frame.size = CGSize(width: (image?.frame.width)! * 2, height: (image?.frame.height)! * 2)
            image?.frame.origin = CGPoint.init(x: self.viewController.view.center.x - (image.frame.width / 2),
                                               y: self.viewController.view.center.y - (image.frame.height / 2))
            
        }, completion: { _ in
            self.viewController.moveTo(state: TurnState(viewController: self.viewController))
        })
    }
    
}




