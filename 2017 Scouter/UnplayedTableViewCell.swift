//
//  UnplayedTableViewCell.swift
//  2017 Scouter
//
//  Created by Ujjwal Nadhani on 12/23/16.
//  Copyright © 2016 Team 8. All rights reserved.
//

import UIKit

class UnplayedTableViewCell: UITableViewCell {

    @IBOutlet weak var redTeams: UILabel!
    @IBOutlet weak var matchAbbr: UILabel!
    @IBOutlet weak var matchNumber: UILabel!
    @IBOutlet weak var blueTeams: UILabel!
    @IBOutlet weak var matchIn: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var viewStatsButton: UIButton?
    
    var match: TBAMatch?
    var parentVC: TeamMatchesViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.borderColor = UIColor.white.cgColor
        container.layer.borderWidth = 1.0
        
        viewStatsButton?.layer.borderColor = UIColor.white.cgColor
        viewStatsButton?.layer.borderWidth = 1.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewStatsPressed(_ sender: Any) {
        self.parentVC?.viewStatsPressed(match!)
    }
}
