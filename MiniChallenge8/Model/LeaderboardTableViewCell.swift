//
//  LeaderboardTableViewCell.swift
//  MiniChallenge8
//
//  Created by Bruno Cruz on 08/06/2018.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
