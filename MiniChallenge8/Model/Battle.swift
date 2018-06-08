//
//  Battle.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation

class Battle {
    
    let championship: Championship
    
    var winner: Player?
    
    let player1: Player
    
    let player2: Player
    
    var rounds: [Round] = []
    
    var player1Percentage: Float = 50
    
    var player2Percentage: Float = 50
    
    init(player1: Player, player2: Player, championship: Championship) {
        self.player1 = player1
        self.player2 = player2
        self.championship = championship
    }
    
    func addPercentageTo(player: Player) {
        if player.peerID == self.player1.peerID && self.player2Percentage > 0 {
            self.player1Percentage += self.championship.feedbackPoint
            self.player2Percentage -= self.championship.feedbackPoint
        } else if player.peerID == self.player2.peerID && self.player1Percentage > 0 {
            self.player1Percentage -= self.championship.feedbackPoint
            self.player2Percentage += self.championship.feedbackPoint
        }
    }
    
    func determineWinner() {
        if self.rounds.count < 3 { return }
        var p1Wins = 0
        var p2Wins = 0
        
        self.rounds.forEach({
            if let winner = $0.winner {
                if winner.peerID == self.player1.peerID {
                    p1Wins += 1
                } else if winner.peerID == self.player2.peerID {
                    p2Wins += 1
                }
            }
        })
        if p1Wins > p2Wins {
            self.winner = self.player1
        } else if p1Wins < p2Wins {
            self.winner = self.player2
        }
    }
    
}
