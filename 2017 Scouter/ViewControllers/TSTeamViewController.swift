
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
    @IBOutlet weak var rankLabel: UILabel!
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
        reloadData()
        
        if(self.navigationStack != nil) {
            self.navigationController?.viewControllers = self.navigationStack!
        }
        
    }
    
    func reloadData() {
        let infoViewController = (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController)
        let matchesViewController = (self.embeddedViewController?.viewControllers?[1] as! TeamMatchesViewController)
        if (infoViewController.infoTable != nil) {
            infoViewController.infoTable.reloadData()
        }
        if (matchesViewController.matchTable != nil) {
            matchesViewController.matchTable.reloadData()
        }
        let team = Data.getTeam(withNumber: self.teamNumber)!
        if let ranking = team.ranking {
            self.rankLabel.text = "Rank #" + String(ranking) + " - " + team.rankingInfo!
        } else {
            self.rankLabel.text = ""
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if(self.previousViewController! is TeamListViewController) {
            self.performSegue(withIdentifier: "teamToTeamList", sender: nil)
        } else if(self.previousViewController! is MatchViewController) {
            self.performSegue(withIdentifier: "unwindTeamToMatch", sender: nil)
        } else if (self.previousViewController! is ViewStatsViewController) {
            self.performSegue(withIdentifier: "unwindTeamToViewStats", sender: nil)
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
            (self.embeddedViewController?.viewControllers?[0] as! TeamInfoViewController).parentVC = self
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
        } else if let vc = segue.destination as? ViewStatsViewController, segue.identifier == "teamToViewStats" {
            vc.previousViewController = self
            vc.timd = sender as? TIMD
        } else if let vc = segue.destination as? ViewStatsViewController, segue.identifier == "unwindTeamToViewStats" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.timd = (self.previousViewController as! ViewStatsViewController).timd
        } else if let vc = segue.destination as? PitScoutingViewController, segue.identifier == "teamToPitScouting" {
            vc.previousViewController = self
            vc.pitScouting = Data.getPitScoutingFirebase(teamNumber: sender as! Int)
            vc.viewing = true
//            print(vc.viewing)
        }
    }
    @IBAction func refresh(_ sender: Any) {
        addActivityIndicator()
        self.view.isUserInteractionEnabled = false
        Data.fetch(complete: fetchComplete)
    }
    
    func refresh() {
        refresh(UIButton())
    }
    
    func addActivityIndicator() {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 250, y: 37, width: 30, height: 30)
        activityIndicator.tag = 100
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
    }
    
    func removeActivityIndicator() {
        if let activityIndicator = self.view.viewWithTag(100) {
            activityIndicator.removeFromSuperview()
        }
    }
    
    func fetchComplete() {
        reloadData()
        removeActivityIndicator()
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func teamUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
