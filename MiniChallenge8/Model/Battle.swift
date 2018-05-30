//
//  Battle.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation

class Battle {
    
    let player1: Player
    
    let player2: Player
    
    var rounds: [Round] = []
    
    var player1Points: Int = 0
    
    var player2Points: Int = 0
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
}
