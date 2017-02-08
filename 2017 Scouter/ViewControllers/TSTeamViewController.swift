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
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var embeddedViewController: UITabBarController?
    
    var previousViewController: ViewController?
    var navigationStack: [UIViewController]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Menu and Back Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        //Change Title to team #
        self.titleLabel.text = "Team " + String(self.teamNumber)
        
        if(self.navigationStack != nil) {
            self.navigationController?.viewControllers = self.navigationStack!
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if(self.previousViewController! is TeamListViewController) {
            self.performSegue(withIdentifier: "teamToTeamList", sender: nil)
        } else if(self.previousViewController! is MatchViewController) {
            self.performSegue(withIdentifier: "unwindTeamToMatch", sender: nil)
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        self.embeddedViewController?.selectedIndex = segmentedControl.selectedSegmentIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        //Send data to embedded view controllers
        if let vc = segue.destination as? UITabBarController, segue.identifier == "teamEmbed" {
            self.embeddedViewController = vc
            (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController).teamNumber = self.teamNumber
            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).teamNumber = self.teamNumber
            (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController).parentVC = self
        //Send data to menu when unwinding
        } else if let vc = segue.destination as? MenuViewController, segue.identifier == "teamToMenu" {
            self.navigationStack = self.navigationController?.viewControllers
            vc.previousViewController = self
            vc.hasPrevious = true
        //Send data to selected match view controller
        } else if let vc = segue.destination as? MatchViewController, segue.identifier == "teamToMatch" {
            vc.match = sender as? TBAMatch
            vc.previousViewController = self
        //Send data to match view controller when unwinding
        } else if let vc = segue.destination as? MatchViewController, segue.identifier == "unwindTeamToMatch" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.match = (self.previousViewController as! MatchViewController).match
        }
    }
    
    @IBAction func teamUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
