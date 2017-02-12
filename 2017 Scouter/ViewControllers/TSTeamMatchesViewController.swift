//
//  TSTeamMatchesViewController.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 1/31/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TeamMatchesViewController: ViewController, UITableViewDataSource, UITableViewDelegate {

    var teamNumber = 0
    
    var parentVC: TeamViewController?
    
    @IBOutlet weak var matchTable: UITableView!
    
//    var matchList = [TBAMatch]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        matchTable.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        matchTable.dataSource = self
        matchTable.delegate = self
    }
//    func populateMatchList() -> Void {
//        
//        //Populating matchList
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDel.managedObjectContext
//        let entity = NSEntityDescription.entity(forEntityName: "Matches", in:managedContext)
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        fetchRequest.entity = entity
//        
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            if (results.count > 0) {
//                if let managedObjectResults = results as? [NSManagedObject]{
//                    for i : NSManagedObject in managedObjectResults{
//                        let unarchivedData : NSData = i.value(forKey: "match") as! NSData
//                        do{
//                            let match : NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
//                            let config = match.value(forKey: "config") as! String
//                            let blueTeams = match.value(forKey: "blue") as! [String]
//                            let redTeams = match.value(forKey: "red") as! [String]
//                            let teamToAppend = TBAMatch(keyV: config, blueAlliance: blueTeams, redAlliance: redTeams)
//                            
//                            TBAMatch.matchListUnordered.append(teamToAppend)
//                            
//                        }catch{
//                            print("core data fetch error")
//                        }
//                        
//                    }
//                }
//                
//            }
//            
//        } catch {
//            let fetchError = error as NSError
//            print(fetchError)
//        }
//        self.matchList = TBAMatch.orderMatches()
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! UnplayedTableViewCell
        let matchList = Data.getTeam(withNumber: self.teamNumber)!.matches
        
        cell.match = matchList[indexPath.row]
        cell.parentVC = self
        
        var blueTeamString = ""
        for blueTeamWithFRC in matchList[indexPath.row].blue{
            let blueTeam : String = String(blueTeamWithFRC.teamNumber)
            blueTeamString += blueTeam
            if blueTeamWithFRC.teamNumber != matchList[indexPath.row].blue[matchList[indexPath.row].blue.count - 1].teamNumber {
                blueTeamString += "\n"
            }
            
        }
        cell.blueTeams.text = blueTeamString
        
        switch matchList[indexPath.row].matchType {
        case TBAMatch.MatchType.qualifying:
            cell.matchAbbr.text = "QM"
            cell.matchNumber.text = String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = ""
        case TBAMatch.MatchType.quarterFinal:
            cell.matchAbbr.text = "QF"
            cell.matchNumber.text =  String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = "Match #" + String(matchList[indexPath.row].matchIn!)
            
        case TBAMatch.MatchType.semiFinal:
            cell.matchAbbr.text = "SF"
            cell.matchNumber.text =  String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = "Match #" + String(matchList[indexPath.row].matchIn!)
            
        case TBAMatch.MatchType.final:
            cell.matchAbbr.text = "F"
            cell.matchNumber.text =  String(matchList[indexPath.row].matchNumber)
            cell.matchIn.text = "Match #" + String(matchList[indexPath.row].matchIn!)
            
        default:
            cell.matchAbbr.text = "UNK"
            
        }
        
        
        var redTeamString = ""
        for redTeamWithFRC in matchList[indexPath.row].red{
            let redTeam : String = String(redTeamWithFRC.teamNumber)
            redTeamString += redTeam
            if redTeamWithFRC.teamNumber != matchList[indexPath.row].red[matchList[indexPath.row].red.count - 1].teamNumber {
                redTeamString += "\n"
            }
        }
        cell.redTeams.text = redTeamString
        
        cell.backgroundColor = UIColor.clear
        
        cell.viewStatsButton?.isEnabled = !(Data.getTIMD(team: Data.getTeam(withNumber: teamNumber)!, match: matchList[indexPath.row]) == nil)
        if (cell.viewStatsButton?.isEnabled)! {
            cell.viewStatsButton?.setTitleColor(UIColor.white, for: .normal)
            cell.viewStatsButton?.layer.borderColor = UIColor.white.cgColor
        } else {
            cell.viewStatsButton?.setTitleColor(UIColor.lightGray, for: .normal)
            cell.viewStatsButton?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! UnplayedTableViewCell
        let match = Data.getTeam(withNumber: self.teamNumber)!.matches[indexPath.row]
        self.parentVC!.performSegue(withIdentifier: "teamToMatch", sender: match)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.getTeam(withNumber: self.teamNumber)!.matches.count
    }

    func viewStatsPressed(_ match: TBAMatch) {
        self.parentVC!.performSegue(withIdentifier: "teamToViewStats", sender: Data.getTIMD(team: Data.getTeam(withNumber: self.teamNumber)!, match: match))
    }
}
