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
        
        var aux: [Player] = self.players
        aux.remove(at: 0)
        
        for p1 in self.players {
            for p2 in aux {
                self.battles.append(Battle(player1: p1, player2: p2, championship: self))
            }
            if aux.count != 0 {
                aux.remove(at: 0)
            }
        }
        
        self.battles.shuffle()
    }
    
    func nextBattle() -> Battle {
        self.battleIndex += 1
        return self.battles[self.battleIndex]
    }
    
    func hasNotNextBattle() -> Bool {
        return self.battles.count == self.battleIndex + 1
    }
    
}

extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
