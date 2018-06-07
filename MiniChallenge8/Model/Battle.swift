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
    
}
