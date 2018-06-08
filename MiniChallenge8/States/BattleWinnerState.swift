//
//  BattleWinnerState.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit

class BattleWinnerState: State {
    
    var viewController: BattleGameViewController
    
    init(viewController: BattleGameViewController) {
        self.viewController = viewController
    }
    
    func didEnterState() {
        self.viewController.battle.determineWinner()
        self.viewController.battle.winner?.victories += 1
        self.viewController.currentStateLabel.text = "fim de jogo"
        if let winner = self.viewController.battle.winner {
            self.show(player: winner)
        } else {
            self.showDraw()
        }
    }
    
    func show(player: Player) {
        var image: UIImageView!
        if self.viewController.battle.player1.peerID == player.peerID {
            image = self.viewController.player1Avatar
        } else {
            image = self.viewController.player2Avatar
        }
        self.viewController.winnerLabel.text = "\(player.name) ganhou a batalha"
        UIView.animate(withDuration: 1, animations: {
            image?.frame.size = CGSize(width: (image?.frame.width)! * 2, height: (image?.frame.height)! * 2)
            image?.frame.origin = CGPoint.init(x: self.viewController.view.center.x - (image.frame.width / 2),
                                               y: self.viewController.view.center.y - (image.frame.height / 2))
            
            self.viewController.currentStateLabel.alpha = 1
            self.viewController.winnerLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: .curveLinear, animations: {
                self.viewController.currentStateLabel.alpha = 0
                self.viewController.winnerLabel.alpha = 0
            }, completion: { _ in
                self.endBattle()
            })
        })
    }
    
    func showDraw() {
        self.viewController.winnerLabel.text = "a batalha empatou!"
        UIView.animate(withDuration: 0.5, animations: {
            self.viewController.currentStateLabel.alpha = 1
            self.viewController.winnerLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: .curveLinear, animations: {
                self.viewController.currentStateLabel.alpha = 0
                self.viewController.winnerLabel.alpha = 0
            }, completion: { _ in
                self.endBattle()
            })
        })
    }
    
    func endBattle() {
        if let leaderboardViewController = self.viewController.storyboard?.instantiateViewController(withIdentifier: "leaderboardViewController") as? LeaderboardViewController, let data = try? JSONEncoder().encode(DisplayScreen(screen: .waiting)) {
            
            MPHelper.shared.send(data: data, dataMode: .reliable)
            leaderboardViewController.championship = self.viewController.battle.championship
            self.viewController.present(leaderboardViewController, animated: true)
        }
    }
    
}
