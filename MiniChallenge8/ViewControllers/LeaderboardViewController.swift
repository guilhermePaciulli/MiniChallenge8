//
//  LeaderboardViewController.swift
//  MiniChallenge8
//
//  Created by Bruno Cruz on 08/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var players = [1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaderboardTableViewCell
        
        cell.playerImage.image = #imageLiteral(resourceName: "rapper3")
        cell.playerNameLabel.text = "mc rodolfera"
        cell.playerPointsLabel.text = "3"
       // cell.backgroundColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
