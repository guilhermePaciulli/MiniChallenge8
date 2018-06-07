//
//  StartBattleState.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 29/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit

class StartBattleState: State {
    
    var viewController: BattleGameViewController
    
    var countdown = 4
    
    init(viewController: BattleGameViewController) {
        self.viewController = viewController
    }
    
    func willEnterState() {
        self.viewController.player1NameLabel.text = self.viewController.battle.player1.name
        self.viewController.player1Avatar.image = self.viewController.battle.player1.avatar
        
        self.viewController.player2NameLabel.text = self.viewController.battle.player2.name
        self.viewController.player2Avatar.image = self.viewController.battle.player2.avatar

        self.viewController.countdownLabel.isHidden = false
    }
    
    func didEnterState() {
        self.timerCountdown()
    }
    
    func didExitState() {
    }
    
    func timerCountdown() {
        if self.countdown == 0 {
            self.viewController.countdownLabel.text = "Valendo"
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.show(player: self.viewController.currentPlayer)
                self.viewController.countdownLabel.isHidden = true
            })
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.viewController.countdownLabel.text = "\(self.countdown)"
                self.countdown -= 1
                self.timerCountdown()
            })
        }
    }
    
    func show(player: Player) {
        var image: UIImageView!
        if self.viewController.battle.player1.peerID == player.peerID {
            image = self.viewController.player1Avatar
        } else {
            image = self.viewController.player2Avatar
        }
        UIView.animate(withDuration: 1, animations: {
            image?.frame.size = CGSize(width: (image?.frame.width)! * 2, height: (image?.frame.height)! * 2)
            image?.frame.origin = CGPoint.init(x: self.viewController.view.center.x - (image.frame.width / 2),
                                               y: self.viewController.view.center.y - (image.frame.height / 2))
            self.viewController.ringView.drawRingFittingInsideView()
        }, completion: { _ in
    
        })
    }
    
}

extension UIView{
    
    func drawRingFittingInsideView(){
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 30.0
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(-.pi/2.0),
            endAngle:CGFloat((3.0 * .pi)/2.0),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.init(red: 151/255, green: 237/255, blue: 181/255, alpha: 1.0).cgColor
        shapeLayer.lineWidth = desiredLineWidth
        shapeLayer.strokeEnd = 0.0
        layer.addSublayer(shapeLayer)
        //animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 60.0
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shapeLayer.strokeEnd = 1.0
        shapeLayer.add(animation, forKey: "animateCircle")
        shapeLayer.animation(forKey: "animateCircle")
    }
    
    
    
}



