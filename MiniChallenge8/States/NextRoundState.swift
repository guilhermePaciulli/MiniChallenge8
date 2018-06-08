//
//  NextRoundState.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit

class NextRoundState: State {
    
    var viewController: BattleGameViewController
    
    init(viewController: BattleGameViewController) {
        self.viewController = viewController
    }
    
    func didEnterState() {
        if self.viewController.battle.player1Percentage > self.viewController.battle.player2Percentage {
            self.viewController.battle.rounds.last!.winner = self.viewController.battle.player1
        } else if self.viewController.battle.player1Percentage < self.viewController.battle.player2Percentage {
            self.viewController.battle.rounds.last!.winner = self.viewController.battle.player2
        }
        
        if self.viewController.battle.rounds.count == 3 {
            self.viewController.moveTo(state: BattleWinnerState(viewController: viewController))
            return
        } else if self.viewController.battle.rounds.count == 2,
            let firstRoundWinner = self.viewController.battle.rounds[0].winner,
            let secondRoundWinner = self.viewController.battle.rounds[1].winner,
            firstRoundWinner.peerID == secondRoundWinner.peerID {
            
            self.viewController.moveTo(state: BattleWinnerState(viewController: viewController))
            return
        }
        
        self.viewController.winnerLabel.alpha = 0
        self.viewController.currentStateLabel.alpha = 0
        
        self.viewController.currentStateLabel.text = "acabou round!"
        if let winnerName = self.viewController.battle.rounds.last?.winner?.name {
            self.viewController.winnerLabel.text = "\(winnerName) ganhou esse round!"
        } else {
            self.viewController.winnerLabel.text = "empate"
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.viewController.winnerLabel.alpha = 1
            self.viewController.currentStateLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: .curveLinear, animations: {
                self.viewController.winnerLabel.alpha = 0
                self.viewController.currentStateLabel.alpha = 0
            }, completion: { _ in
                self.viewController.battle.rounds.append(Round())
                self.viewController.moveTo(state: StartTurnState(viewController: self.viewController))
            })
        })
        
    }
    
}
