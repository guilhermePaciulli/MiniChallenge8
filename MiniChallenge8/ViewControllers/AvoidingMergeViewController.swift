//
//  AvoidingMergeViewController.swift
//  MiniChallenge8
//
//  Created by Bruno Cruz on 04/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class AvoidingMergeViewController: UIViewController {

    @IBOutlet weak var ringView: UIView!
    
    @IBOutlet weak var player1PercentageLabel: UILabel!
    @IBOutlet weak var player2Percentagelabel: UILabel!
    
    @IBOutlet weak var player1Bar: UIView!
    @IBOutlet weak var player2Bar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.ringView.drawRingFittingInsideView()
        self.player2Bar.backgroundColor = UIColor.red
        self.player1Bar.backgroundColor = UIColor.blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func increaseP2Bar(_ sender: Any) {
        self.player2Bar.frame.size.width += 8
        self.player1Bar.frame.size.width -= 8
        self.player1Bar.frame.origin.x += 8
    }
    
}

extension UIView{
    
    func drawRingFittingInsideView(){
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 8.0
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(-.pi/2.0),
            endAngle:CGFloat((3.0 * .pi)/2.0),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        shapeLayer.strokeEnd = 0.0
        layer.addSublayer(shapeLayer)
       //animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shapeLayer.strokeEnd = 1.0
        shapeLayer.add(animation, forKey: "animateCircle")
        shapeLayer.animation(forKey: "animateCircle")
    }
    
    

}
