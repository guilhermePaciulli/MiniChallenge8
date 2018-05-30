//
//  BattleGameViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class BattleGameViewController: UIViewController {
    
    var currentState: State!
    
    var battle: Battle!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentState = StartBattleState(viewController: self)
        if let didEnterState = self.currentState.didEnterState {
            didEnterState()
        }
    }
    
    func moveTo(state: State) {
        if let didExitState = self.currentState.didExitState { didExitState() }
        self.currentState = state
        if let didEnterState = self.currentState.didEnterState { didEnterState() }
    }

}
