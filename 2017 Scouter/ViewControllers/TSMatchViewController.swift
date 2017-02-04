//
//  TSMatchViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/3/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class MatchViewController: ViewController {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var redAllianceView: MatchAllianceView!
    @IBOutlet weak var blueAllianceView: MatchAllianceView!
    
    var match: TBAMatch?
    
    var previousViewController: ViewController?
    var navigationStack: [UIViewController]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        //Change Title to match #
        let matchKey = self.match!.key
        self.titleLabel.text = matchKey.components(separatedBy: "_")[1].uppercased()
        
        if(self.navigationStack != nil) {
            self.navigationController?.viewControllers = self.navigationStack!
        }
    }
    @IBAction func viewTBAPressed(_ sender: Any) {
    }
    @IBAction func refresh(_ sender: Any) {
    }
}
class MatchAllianceView: UIView {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var fourRotor: UIImageView!
    @IBOutlet weak var fortyKPa: UIImageView!
    @IBOutlet var teamButtons: [UIButton]!
    @IBOutlet var viewStatButtons: [UIButton]!
}
