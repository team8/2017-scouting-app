//
//  TSTeamViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 1/29/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class TeamViewController: ViewController {
    
//    @IBOutlet weak var matchTable: UITableView!
    var teamNumber = 0
    var matchList = [TBAMatch]()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var embeddedViewController: UITabBarController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        self.embeddedViewController?.selectedIndex = segmentedControl.selectedSegmentIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let vc = segue.destination as? UITabBarController, segue.identifier == "teamEmbed" {
            self.embeddedViewController = vc
            (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController).teamNumber = self.teamNumber
        }
    }
}