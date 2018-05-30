//
//  PreBattleViewController.swift
//  MiniChallenge8iOS
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class PreBattleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let opponentStarterGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSelectOpponentStarter))
        opponentStarterGestureRecognizer.direction = .up
        let playerStarterGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSelectPlayerStarter))
        playerStarterGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(opponentStarterGestureRecognizer)
        self.view.addGestureRecognizer(playerStarterGestureRecognizer)
    }
    
    @objc func didSelectPlayerStarter() {
        self.send(starter: .player)
    }
    
    @objc func didSelectOpponentStarter() {
        self.send(starter: .opponent)
    }
    
    private func send(starter: Starter) {
        if let starterStructData = try? JSONEncoder().encode(ChooseStarterStruct.init(starter: starter)) {
            MPHelper.shared.send(data: starterStructData, dataMode: .reliable)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let waitingViewController = storyboard.instantiateViewController(withIdentifier: "waitingViewController")
            self.dismiss(animated: true)
            self.present(waitingViewController, animated: true, completion: {})
        }
    }
    
}

