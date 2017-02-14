//
//  TSViewStatsViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/10/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class ViewStatsViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var viewTeamButton: UIButton!
    @IBOutlet weak var viewMatchButton: UIButton!
    
    @IBOutlet weak var statsTable: UITableView!
    
    var previousViewController: ViewController?
    var navigationStack: [UIViewController]?
    
    var timd: TIMD?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        //Change Title to match #
        let teamNumber = String(self.timd!.team.teamNumber)
        let matchKey = self.timd!.match.key
        self.titleLabel.text = "Stats For Team " + teamNumber + " in " + matchKey.components(separatedBy: "_")[1].uppercased()
        
        reloadData()
        
        //Table stuff
        statsTable.delegate = self
        statsTable.dataSource = self
        statsTable.backgroundColor = UIColor.clear
        
        //Borders
        viewTeamButton.layer.borderWidth = 1
        viewTeamButton.layer.borderColor = UIColor.white.cgColor
        viewMatchButton.layer.borderWidth = 1
        viewMatchButton.layer.borderColor = UIColor.white.cgColor
        
        //Set navigation stack
        if(self.navigationStack != nil) {
            self.navigationController?.viewControllers = self.navigationStack!
        }
    }
    
    func reloadData() {
        statsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath)
        
        let key = Array(timd!.stats.keys)[indexPath.row]
        let value = String(describing: timd!.stats[key]!)
        cell.textLabel?.text = key + ": " + value
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let vc = segue.destination as? MenuViewController, segue.identifier == "teamToMenu" {
            self.navigationStack = self.navigationController?.viewControllers
            vc.previousViewController = self
            vc.hasPrevious = true
            //Send data to selected match view controller
        } else if let vc = segue.destination as? MatchViewController, segue.identifier == "viewStatsToMatch" {
            vc.match = sender as? TBAMatch
            vc.previousViewController = self
            //Send data to match view controller when unwinding
        } else if let vc = segue.destination as? MatchViewController, segue.identifier == "unwindViewStatsToMatch" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.match = (self.previousViewController as! MatchViewController).match
        } else if let vc = segue.destination as? TeamViewController, segue.identifier == "viewStatsToTeam" {
            vc.previousViewController = self
            vc.teamNumber = sender as! Int
        } else if let vc = segue.destination as? TeamViewController, segue.identifier == "unwindViewStatsToTeam" {
            let navStack = self.navigationController?.viewControllers
            vc.previousViewController = navStack?[(navStack?.count)! - 3] as! ViewController?
            vc.teamNumber = (self.previousViewController as! TeamViewController).teamNumber
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (timd?.stats.count)!
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if (self.previousViewController! is MatchViewController) {
            self.performSegue(withIdentifier: "unwindViewStatsToMatch", sender: nil)
        } else if (self.previousViewController! is TeamViewController) {
            self.performSegue(withIdentifier: "unwindViewStatsToTeam", sender: nil)
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        addActivityIndicator()
        self.view.isUserInteractionEnabled = false
        Data.fetch(complete: fetchComplete)
    }
    
    func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 247, y: 47, width: 30, height: 30)
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
    
    @IBAction func viewTeamButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "viewStatsToTeam", sender: self.timd!.team.teamNumber)
    }
    @IBAction func viewMatchButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "viewStatsToMatch", sender: self.timd!.match)
    }
    
    @IBAction func viewStatsUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}
