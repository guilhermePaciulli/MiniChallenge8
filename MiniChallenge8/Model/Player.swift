//
//  Player.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class Player {
    
    let name: String
    
    let avatar: UIImage
    
    let peerID: MCPeerID
    
    init(name: String, avatar: Avatar, peerID: MCPeerID) {
        self.name = name
        self.avatar = UIImage(named: avatar.rawValue)!
        self.peerID = peerID
    }
    
}

enum Avatar: String, Codable {
    case rapper1 = "rapper1.png"
    case rapper2 = "rapper2.png"
    case rapper3 = "rapper3.png"
    case rapper4 = "rapper4.png"
    case rapper5 = "rapper5.png"
}
