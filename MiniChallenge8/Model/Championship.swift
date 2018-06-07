//
//  Championship.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation

class Championship {
    
    var battles: [Battle] = []
    
    var players: [Player]
    
    var battleIndex: Int = -1
    
    var feedbackPoint: Float
    
    init(players: [Player]) {
        self.players = players
        switch self.players.count {
        case 3:
            self.feedbackPoint = 1.0
        case 4:
            self.feedbackPoint = 0.7
        case 5:
            self.feedbackPoint = 0.5
        case 6:
            self.feedbackPoint = 0.3
        default:
            self.feedbackPoint = 1
        }
        
        for p1 in players {
            var added: [Player] = []
            for p2 in players {
                if p1.peerID != p2.peerID && !(added.contains(where: { $0.peerID == p2.peerID })) {
                    self.battles.append(Battle(player1: p1, player2: p2, championship: self))
                    added.append(p2)
                }
            }
        }
    }
    
    func nextBattle() -> Battle {
        self.battleIndex += 1
        return self.battles[self.battleIndex + 1]
    }
    
}
