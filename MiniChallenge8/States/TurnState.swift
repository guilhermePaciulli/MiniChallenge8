//
//  TurnState.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class TurnState: State {
    
    var viewController: BattleGameViewController
    
    var didStartTurn = false
    
    var ringShapeLayer: CAShapeLayer?
    
    init(viewController: BattleGameViewController) {
        self.viewController = viewController
    }
    
    func didEnterState() {
        
        if let datum = try? JSONEncoder().encode(DisplayScreen(screen: .feedbackView)) {
            let playersPeerIDs = self.viewController.battle.championship.players.filter({ $0.peerID != self.viewController.battle.player1.peerID && $0.peerID != self.viewController.battle.player2.peerID })
//            let playersPeerIDs = self.viewController.battle.championship.players.filter({ $0.peerID != self.viewController.currentPlayer.peerID })
            MPHelper.shared.send(data: datum, dataMode: .reliable, for: playersPeerIDs.map({ return $0.peerID }))
        }
        
        self.viewController.ringView.alpha = 0
        self.ringShapeLayer = self.drawRingFittingInside(view: self.viewController.ringView)
        UIView.animate(withDuration: 0.2, animations: {
            self.viewController.ringView.alpha = 1
        }, completion: { _ in
            self.didStartTurn = true
            self.ringDecreaseAnimation()
        })
    }
    
    func didExitState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewController.ringView.alpha = 0
        }, completion: { _ in
            self.didStartTurn = false
        })
        
        //Posicionar personagem
    }
    
    func ringDecreaseAnimation() {
        guard let shapeLayer = self.ringShapeLayer else { return }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 15.0
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shapeLayer.strokeEnd = 1.0
        shapeLayer.add(animation, forKey: "animateCircle")
        shapeLayer.animation(forKey: "animateCircle")

    }
    
    func drawRingFittingInside(view: UIView) -> CAShapeLayer {
        let halfSize: CGFloat = min(view.bounds.size.width / 2, view.bounds.size.height / 2)
        let desiredLineWidth: CGFloat = 30.0
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: view.bounds.size.width/2.0, y: view.bounds.size.height/2.0),
            radius: CGFloat(halfSize - (desiredLineWidth/2)),
            startAngle: CGFloat(-.pi/2.0),
            endAngle:CGFloat((3.0 * .pi)/2.0),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.init(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = desiredLineWidth
        shapeLayer.strokeEnd = 0.0
        view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    func updateRemainingTime() {
        self.ringShapeLayer?.timeOffset = (self.ringShapeLayer?.convertTime(CACurrentMediaTime(), from: nil))!
        self.ringShapeLayer?.beginTime = CACurrentMediaTime()
        self.ringShapeLayer?.speed /= 20
    }
    
    func updatePercentages() {
        self.viewController.battle.addPercentageTo(player: self.viewController.currentPlayer)
        
        self.viewController.player1PercentageLabel.text = "\(self.viewController.battle.player1Percentage)%"
        self.viewController.player2PercentageLabel.text = "\(self.viewController.battle.player2Percentage)%"
        
        DispatchQueue.main.async {
            let oldValue = self.viewController.player1Bar.frame.size.width
            self.viewController.player1Bar.frame.size.width = CGFloat(self.viewController.barWidth) * CGFloat(self.viewController.battle.player1Percentage) / 50
            self.viewController.player2Bar.frame.size.width = CGFloat(self.viewController.barWidth) * CGFloat(self.viewController.battle.player2Percentage) / 50
            if self.viewController.currentPlayer.peerID == self.viewController.battle.player1.peerID {
                self.viewController.player1Bar.frame.origin.x -= abs(oldValue - self.viewController.player1Bar.frame.size.width)
            } else {
                self.viewController.player1Bar.frame.origin.x += abs(oldValue - self.viewController.player1Bar.frame.size.width)
            }
        }
        
    }
    
    func didReceive(data: Data, from peerID: MCPeerID) {
        if (try? JSONDecoder().decode(FeedbackStruct.self, from: data)) != nil {
            self.updateRemainingTime()
            self.updatePercentages()
        }
    }
    
}
