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
    
    var battleIndex: Int = -1
    
    init(players: [Player]) {
        for p1 in players {
            var added: [Player] = []
            for p2 in players {
                if p1.peerID != p2.peerID && !(added.contains(where: { $0.peerID == p2.peerID })) {
                    self.battles.append(Battle(player1: p1, player2: p2))
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
