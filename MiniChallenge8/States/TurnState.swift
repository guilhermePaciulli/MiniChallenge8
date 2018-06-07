//
//  TurnState.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit

class TurnState: State {
    
    var viewController: BattleGameViewController
    
    init(viewController: BattleGameViewController) {
        self.viewController = viewController
    }
    
    func didEnterState() {
        //Aparecer com o ring
    }
    
    func didExitState() {
        //Desaparecer com o ring
        //Posicionar personagem
    }
    
}
