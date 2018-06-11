//
//  State.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

@objc protocol State {
    var viewController: BattleGameViewController { get set }
    
    @objc optional func willEnterState()
    @objc optional func didEnterState()
    @objc optional func didExitState()
    @objc optional func didReceiveFeedbackFromTV()
    @objc optional func didPressMainButton()
    @objc optional func didReceive(data: Data, from peerID: MCPeerID)
    @objc optional func animationDidStop(_ animation: CAAnimation)
}
