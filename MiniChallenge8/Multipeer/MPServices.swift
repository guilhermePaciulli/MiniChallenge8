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
    
    convenience init(name: String, avatar: String) {
        self.init(name: name, avatar: Avatar.init(rawValue: avatar)!)
    }
    
}

class ChooseStarterStruct: Codable {
    let starter: Starter
    init(starter: Starter) {
        self.starter = starter
    }
}

class FeedbackStruct: Codable {
    var feed = "feedback"
}

class DisplayScreen: Codable {
    let screen: Screen
    init(screen: Screen) {
        self.screen = screen
    }
}

enum Screen: String, Codable {
    case waiting = "waitingScreen"
    case characterEditing = "characterEditingScreen"
    case chooseStarter = "chooseStarterScreen"
    case feedbackView = "feedbackView"
}

enum Starter: String, Codable {
    case player = "player"
    case opponent = "opponent"
}
