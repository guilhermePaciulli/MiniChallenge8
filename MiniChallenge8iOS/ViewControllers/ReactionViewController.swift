//
//  ReactionViewController.swift
//  MiniChallenge8iOS
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ReactionViewController: UIViewController {
    
    var feedbackStructData: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        let reactGesture = UITapGestureRecognizer.init(target: self, action: #selector(didReact))
        self.view.addGestureRecognizer(reactGesture)
        if let feedbackStructData = try? JSONEncoder().encode(FeedbackStruct()) {
            self.feedbackStructData = feedbackStructData
        }
    }
    
    @objc func didReact() {
        MPHelper.shared.send(data: self.feedbackStructData, dataMode: .reliable)
    }

}

extension ReactionViewController: ReceiverDelegate {
    
    func receive(data: Data, from peer: MCPeerID) {
        if let screen = try? JSONDecoder().decode(DisplayScreen.self, from: data), screen.screen == .waiting {
            if let waitingViewController = self.storyboard?.instantiateViewController(withIdentifier: "waitingViewController") {
                self.present(waitingViewController, animated: true, completion: nil)
            }
        }
    }
    
    func receive(error: Error) { }
    
}
