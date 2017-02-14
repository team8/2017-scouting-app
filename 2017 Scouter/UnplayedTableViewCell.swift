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
    @IBOutlet weak var blueTeams: UILabel!
    @IBOutlet weak var redScore: UILabel!
    @IBOutlet weak var blueScore: UILabel!
    @IBOutlet weak var matchKey: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var overlayView: UIView!
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
        //        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.5, animations: {
            if (selected) {
                self.overlayView.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
            } else {
                self.overlayView.backgroundColor = UIColor.clear
            }
        })
        // Configure the view for the selected state
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }

    @IBAction func viewStatsPressed(_ sender: Any) {
        self.parentVC?.viewStatsPressed(match!)
    }
}
