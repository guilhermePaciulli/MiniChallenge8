//
//  MPServices.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PlayerStruct: Codable {
    
    let name: String
    
    let avatar: Avatar
    
    init(name: String, avatar: Avatar) {
        self.name = name
        self.avatar = avatar
    }
    
    func buildPlayer(with peerID: MCPeerID) -> Player {
        return Player(name: self.name, avatar: self.avatar, peerID: peerID)
    }
    
}

class FeedbackStruct: Codable {
    
}

class DisplayScreen: Codable {
    
    let screen: Screen
    
    init(screen: Screen) {
        self.screen = screen
    }
}

enum Screen: String, Codable {
    case waiting = "waitingScreen"
}
