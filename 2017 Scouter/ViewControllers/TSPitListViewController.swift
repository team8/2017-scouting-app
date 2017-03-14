//
//  TSPitListViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/23/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class PitListViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var scoutNewTeamButton: UIButton!
    @IBOutlet weak var teamTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Menu Button Image Sizing
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        teamTable.backgroundColor = UIColor.clear
        
        self.teamTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamTable.dataSource = self
        teamTable.delegate = self
    }
    
    //Table stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PitListCell", for: indexPath) as! PitTeamTableViewCell
        
        let teamNumber = Data.pitScoutingList[indexPath.row].teamNumber
        
        cell.teamNum = teamNumber!
        cell.teamNumber.text = String(teamNumber!)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PitTeamTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "pitListToPitScouting", sender: cell.teamNum)
    }

    //Send team number data to pit scouting view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "pitListToPitScouting") {
            let secondViewController = segue.destination as! PitScoutingViewController
            secondViewController.previousViewController = self
            if let teamNumber = sender {
                secondViewController.pitScouting = Data.getPitScoutingLocal(teamNumber: teamNumber as! Int)
                secondViewController.viewing = true
            } else {
                secondViewController.pitScouting = PitScouting(local: true)
                secondViewController.viewing = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.pitScoutingList.count
    }
    
    @IBAction func scoutNewTeamPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "pitListToPitScouting", sender: nil)
    }
    //Unwind segue
    @IBAction func pitListUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
}

class PitTeamTableViewCell: UITableViewCell {
    
    var teamNum = 0
    
    @IBOutlet weak var teamNumber: UILabel!
    @IBOutlet weak var uploadStatus: UIImageView!
    
}
