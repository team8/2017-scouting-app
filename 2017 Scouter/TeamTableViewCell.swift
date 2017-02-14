//
//  TeamTableViewCell.swift
//  2017 Scouter
//
//  Created by Ujjwal Nadhani on 12/28/16.
//  Copyright © 2016 Team 8. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    var teamNum = 0
    
    @IBOutlet weak var rankingNumber: UILabel!
    @IBOutlet weak var teamNumber: UILabel!
    @IBOutlet weak var sortStat: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 1.0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.5, animations: {
            if (selected) {
                self.containerView.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
            } else {
                self.containerView.backgroundColor = UIColor.clear
            }
        })
        // Configure the view for the selected state
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
}
