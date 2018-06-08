//
//  LeaderboardViewController.swift
//  MiniChallenge8
//
//  Created by Bruno Cruz on 08/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import AVFoundation

class LeaderboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var players: [Player] = []
    
    var championship: Championship!
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.playSong()
        self.players = self.championship.players
        self.players.sort(by: { $0.victories > $1.victories })
        
        if self.championship.hasNotNextBattle() {
            self.continueButton.setTitle("Terminar", for: .normal)
        }
        
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
        let player = self.players[indexPath.row]
        cell.playerImage.image = player.avatar
        cell.playerNameLabel.text = player.name
        cell.playerPointsLabel.text = "\(player.victories)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    @IBAction func continueToNextBattle(_ sender: Any) {
        if self.championship.hasNotNextBattle() {
            if let connectedPlayersViewController = self.storyboard?.instantiateViewController(withIdentifier: "connectedPlayersViewController") as? ConnectedPlayersViewController {
                self.present(connectedPlayersViewController, animated: true)
            }
        } else {
            if let preBattleViewController = self.storyboard?.instantiateViewController(withIdentifier: "preBattleViewController") as? PreBattleViewControllerTVOS {
                preBattleViewController.championship = self.championship
                preBattleViewController.audioPlayer = self.audioPlayer
                self.present(preBattleViewController, animated: true)
            }
        }
    }
    func playSong(){
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "beat02-tvOS", ofType: "mp3")!)
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: sound)
            self.audioPlayer.prepareToPlay()
        }catch{
            print("problem in playing music")
        }
        self.audioPlayer.play()
        self.audioPlayer.volume = 0.25
        self.audioPlayer.numberOfLoops = -1
    }
}
