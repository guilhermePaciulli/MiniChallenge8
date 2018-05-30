//
//  Turn.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation

class Turn {
    
    var player: Player
    
    var score: Int
    
    init(player: Player) {
        self.player = player
        self.score = 0
    }
    
}
