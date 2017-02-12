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
        
        reloadData()
        
        //Borders
        for (button) in self.redAllianceView.teamButtons! {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        for (button) in self.redAllianceView.viewStatButtons! {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        for (button) in self.blueAllianceView.teamButtons! {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        for (button) in self.blueAllianceView.viewStatButtons! {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        
        //Set navigation stack
        if(self.navigationStack != nil) {
            self.navigationController?.viewControllers = self.navigationStack!
        }
    }
    
    func reloadData() {
        //Change scores and match stats
        //Parent
        self.redAllianceView.parent = self
        self.blueAllianceView.parent = self
        //Scores
        self.redAllianceView.score.text = String(self.match!.redScore!)
        self.blueAllianceView.score.text = String(self.match!.blueScore!)
        //Winner/loser/tie
        if(self.match!.redScore! > self.match!.blueScore!) {
            self.redAllianceView.winner.text = "Winner"
            self.redAllianceView.score.font = UIFont(name: "Lato-Bold", size: 50)
            self.blueAllianceView.winner.text = "Loser"
        } else if(self.match!.redScore! < self.match!.blueScore!) {
            self.redAllianceView.winner.text = "Loser"
            self.blueAllianceView.winner.text = "Winner"
            self.blueAllianceView.score.font = UIFont(name: "Lato-Bold", size: 50)
        } else {
            self.redAllianceView.winner.text = "Tie"
            self.blueAllianceView.winner.text = "Tie"
        }
        
        //Match stats
        //        if(!self.match!.redFourRotor!) {
        //            self.redAllianceView.fourRotor.image = UIImage(named: "four-rotor-false")
        //        }
        //        if(!self.match!.blueFourRotor!) {
        //            self.blueAllianceView.fourRotor.image = UIImage(named: "four-rotor-false")
        //        }
        self.redAllianceView.rotorLabel.text = String(self.match!.redRotor!)
        self.blueAllianceView.rotorLabel.text = String(self.match!.blueRotor!)
        if(!self.match!.redFortyKPa!) {
            self.redAllianceView.fortyKPa.image = UIImage(named: "forty-kpa-false")
        } else {
            self.redAllianceView.fortyKPa.image = UIImage(named: "forty-kpa-true")
        }
        if(!self.match!.blueFortyKPa!) {
            self.blueAllianceView.fortyKPa.image = UIImage(named: "forty-kpa-false")
        } else {
            self.blueAllianceView.fortyKPa.image = UIImage(named: "forty-kpa-true")
        }
        
        //Teams
        for (i, button) in self.redAllianceView.teamButtons.enumerated() {
            button.setTitle(String(self.match!.red[i].teamNumber), for: .normal)
        }
        for (i, button) in self.blueAllianceView.teamButtons.enumerated() {
            button.setTitle(String(self.match!.blue[i].teamNumber), for: .normal)
        }
        self.redAllianceView.teams = self.match!.red
        self.blueAllianceView.teams = self.match!.blue
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if (self.previousViewController! is MatchListViewController) {
            self.performSegue(withIdentifier: "unwindMatchToMatchList", sender: nil)
        } else if (self.previousViewController! is TeamViewController) {
            self.performSegue(withIdentifier: "unwindMatchToTeam", sender: nil)
        } else if (self.previousViewController! is ViewStatsViewController) {
            self.performSegue(withIdentifier: "unwindMatchToViewStats", sender: nil)
        }
    }
    @IBAction func viewTBAPressed(_ sender: Any) {
    }
    @IBAction func refresh(_ sender: Any) {
        addActivityIndicator()
        self.view.isUserInteractionEnabled = false
        Data.fetch(complete: fetchComplete)
    }
    
    func addActivityIndicator() {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 230, y: 37, width: 30, height: 30)
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
    
    //Sending info to next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let vc = segue.destination as? MenuViewController, segue.identifier == "matchToMenu" {
            self.navigationStack = self.navigationController?.viewControllers
            vc.previousViewController = self
            vc.hasPrevious = true
        } else if let vc = segue.destination as? TeamViewController, segue.identifier == "matchToTeam" {
            vc.previousViewController = self
            vc.teamNumber = sender as! Int
        } else if let vc = segue.destination as? TeamViewController, segue.identifier == "unwindMatchToTeam" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.teamNumber = (self.previousViewController as! TeamViewController).teamNumber
        } else if let vc = segue.destination as? ViewStatsViewController, segue.identifier == "matchToViewStats" {
            vc.previousViewController = self
            vc.timd = sender as? TIMD
        } else if let vc = segue.destination as? ViewStatsViewController, segue.identifier == "unwindMatchToViewStats" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.timd = (self.previousViewController as! ViewStatsViewController).timd
        }
    }
    
    @IBAction func matchUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
class MatchAllianceView: UIView {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var winner: UILabel!
    @IBOutlet weak var rotorLabel: UILabel!
    @IBOutlet weak var fortyKPa: UIImageView!
    @IBOutlet var teamButtons: [UIButton]!
    @IBOutlet var viewStatButtons: [UIButton]!
    
    var parent: MatchViewController?
    var teams = [Team]()
    
    @IBAction func teamButtonPressed(_ sender: UIButton) {
        parent!.performSegue(withIdentifier: "matchToTeam", sender: teams[sender.tag].teamNumber)
    }
    
    @IBAction func viewStatsButtonPressed(_ sender: UIButton) {
        parent!.performSegue(withIdentifier: "matchToViewStats", sender: Data.getTIMD(team: teams[sender.tag], match: parent!.match!))
    }
}
