//
//  WaitingViewController.swift
//  MiniChallenge8
//
//  Created by Guilherme Paciulli on 30/05/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {
    
    @IBOutlet weak var waitingLabel: UILabel!
    var control:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
         
            switch self.control{
            case 0:
                self.waitingLabel.text = "aguardando"
                self.control += 1
            case 1:
                self.waitingLabel.text = "aguardando ."
                self.control += 1
            case 2:
                self.waitingLabel.text = "aguardando . ."
                self.control += 1
            case 3:
                self.waitingLabel.text = "aguardando . . ."
                self.control = 0
           default:
                break
            }
        }
    }

    
    
}
