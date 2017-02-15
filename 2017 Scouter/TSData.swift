//
//  Data.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Data {
    
    static var competition: String?
    
    static var teamList = [Team]()
    static var matchList = [TBAMatch]()
    static var timdList = [TIMD]()
    
    static let fetchesTotal = 2
    static var fetchesComplete = 0
    static var completeFunction: (() -> Void)?
    
    static func fetch(complete: @escaping () -> Void) {
        ServerInterfacer.getTeams(handleTeamJSON, key: Data.competition!)
//        ServerInterfacer.getTeams(handleTeamJSON, key: "2016casj")
        ServerInterfacer.getMatches(handleMatchJSON, key: Data.competition!)
//        ServerInterfacer.getMatches(handleMatchJSON, key: "2016casj")
        completeFunction = complete
    }
    
    static func finishFetch() {
        FirebaseInteractor.getFirebaseData(handleFirebaseJSON, forKey: Data.competition!)
//        FirebaseInteractor.getFirebaseData(handleFirebaseJSON, forKey: "2016casj")
    }
    
    static func fetchComplete() {
        fetchesComplete += 1
        if fetchesComplete == fetchesTotal {
            finishFetch()
//            completeFunction!()
            fetchesComplete = 0
        }
    }
    
    static func handleTeamJSON(value: NSDictionary) -> Void {
        if (((value.value(forKey: "query") as! NSDictionary).value(forKey: "success"))! as! String == "yes") {
            for (team) in teamList {
                team.deleteFromCoreData()
            }
            teamList.removeAll()
            for (_, value) in (value.value(forKey: "query") as! NSDictionary).value(forKey: "teams") as! NSDictionary {
                let payloadDict = value as! NSDictionary
                
                let teamNumber = payloadDict.object(forKey: "team_number") as! Int
                let team = Team(teamNumber: teamNumber)
//                team.saveToCoreData()
                teamList.append(team)
                
            }
//            print(teamList)
        } else {
            print(value)
        }
        fetchComplete()
    }
    
    static func handleMatchJSON(value: NSDictionary) -> Void {
        if (((value.value(forKey: "query") as! NSDictionary).value(forKey: "success"))! as! String == "yes") {
            for (match) in matchList {
                match.deleteFromCoreData()
            }
            matchList.removeAll()
            if (Data.teamList.count == 0){
                print("death")
                ServerInterfacer.getTeams(handleTeamJSON, key: Data.competition!)
                ServerInterfacer.getMatches(handleMatchJSON, key: Data.competition!)
                return
            }

            for (key, value) in (value.value(forKey: "query") as! NSDictionary).value(forKey: "matches") as! NSDictionary {
                let name = key as! String
                
                let payloadDict = value as! NSDictionary
                
                var blue = [Team]()
                for (num) in (payloadDict.object(forKey: "blue") as! [Int]) {
                    blue.append(Data.getTeam(withNumber: num)!)
                }
                var red = [Team]()
                for (num) in (payloadDict.object(forKey: "red") as! [Int]) {
                    red.append(Data.getTeam(withNumber: num)!)
                }
                let scoreBreakdown = payloadDict.object(forKey: "score_breakdown") as! NSDictionary
                let match = TBAMatch(keyV: name, blueAlliance: blue, redAlliance: red, scoreBreakdown: scoreBreakdown)
//                match.saveToCoreData()
                matchList.append(match)
                
            }
            
            orderMatches()
            
            //Populate teams with matches
            for (team) in teamList {
                team.matches = getMatches(withTeam: team)
            }
        }
        else {
            print(value)
        }
        
        fetchComplete()

        
    }
    
    static func handleFirebaseJSON(value: NSDictionary) -> Void {
        if (((value.value(forKey: "query") as! NSDictionary).value(forKey: "success"))! as! String == "yes") {
            let teams = (value.value(forKey: "query") as! NSDictionary).value(forKey: "teams") as! NSDictionary
            //Set team data
            for (team) in teamList {
                if let t = teams.value(forKey: "frc" + String(team.teamNumber)) {
                    let data = (t as! NSDictionary).value(forKey: "data") as! NSDictionary
                    team.setFirebaseData(data: data)
                }
            }
            
            //Extract TIMD data
            for (timd) in timdList {
                timd.deleteFromCoreData()
            }
            timdList.removeAll()
            for (teamKey, value) in teams {
                let teamDict = value as! NSDictionary
                let teamNumber = Int((teamKey as! String).components(separatedBy: "frc")[1])!
                let team = Data.getTeam(withNumber: teamNumber)!
                for (matchKey, data) in teamDict.value(forKey: "timd") as! NSDictionary {
                    let match = Data.getMatch(withKey: Data.competition! + "_" + (matchKey as! String))!
                    let timd = TIMD(team: team, match: match, data: data as! NSDictionary)
//                    timd.saveToCoreData()
                    timdList.append(timd)
                }
            }
            
            //Fetch finished
            completeFunction!()
            saveAllToCoreData()
        }
        else {
            print(value)
        }
    }
    
    static func saveAllToCoreData() {
        for (team) in teamList {
            team.saveToCoreData()
        }
        for (match) in matchList {
            match.saveToCoreData()
        }
        for (timd) in timdList {
            timd.saveToCoreData()
        }
    }
    
    static func fetchFromCoreData(event: String) {
        fetchTeamsFromCoreData(event: event)
        fetchMatchesFromCoreData(event: event)
        fetchTIMDsFromCoreData(event: event)
    }
    
    static func fetchTeamsFromCoreData(event: String) {
        //Clear list
        teamList.removeAll()
        
        //Getting stuff from the appDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Teams", in: managedContext)
        
        //Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if (results.count > 0) {
                if let managedObjectResults = results as? [NSManagedObject] {
                    for i: NSManagedObject in managedObjectResults {
                        if (i.value(forKey: "event") as! String == Data.competition!) {
                            teamList.append(Team(i))
                        }
                    }
                }
        
            }
        
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    static func fetchMatchesFromCoreData(event: String) {
        //Clear list
        matchList.removeAll()
        
        //Getting stuff from the appDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Matches", in: managedContext)
        
        //Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if (results.count > 0) {
                if let managedObjectResults = results as? [NSManagedObject] {
                    for i: NSManagedObject in managedObjectResults {
                        if (i.value(forKey: "event") as! String == Data.competition!) {
                            matchList.append(TBAMatch(i))
                        }
                    }
                    orderMatches()
                    
                    //Populate teams with matches
                    for (team) in teamList {
                        team.matches = getMatches(withTeam: team)
                    }
                }
                
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    static func fetchTIMDsFromCoreData(event: String) {
        //Clear list
        timdList.removeAll()
        
        //Getting stuff from the appDelegate
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "TIMDs", in: managedContext)
        
        //Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if (results.count > 0) {
                if let managedObjectResults = results as? [NSManagedObject] {
                    for i: NSManagedObject in managedObjectResults {
                        if (i.value(forKey: "event") as! String == Data.competition!) {
                            timdList.append(TIMD(i))
                        }
                    }
                }
                
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    static func orderMatches() {
        var qualifyingMatches = [TBAMatch]()
        var quarterFinals = [TBAMatch]()
        var semiFinals = [TBAMatch]()
        var finals = [TBAMatch]()
        var unknowns = [TBAMatch]()
        
        for matchToAssign : TBAMatch in Data.matchList {
            switch matchToAssign.matchType {
            case TBAMatch.MatchType.qualifying:
                qualifyingMatches.append(matchToAssign)
            case TBAMatch.MatchType.quarterFinal:
                quarterFinals.append(matchToAssign)
            case TBAMatch.MatchType.semiFinal:
                semiFinals.append(matchToAssign)
            case TBAMatch.MatchType.final:
                finals.append(matchToAssign)
            default:
                unknowns.append(matchToAssign)
            }
        }
        
        qualifyingMatches = qualifyingMatches.sorted{ return $0.matchNumber < $1.matchNumber}
        quarterFinals = quarterFinals.sorted{a,b in
            if a.matchNumber != b.matchNumber{
                return a.matchNumber < b.matchNumber
            }else{
                return a.matchIn! < b.matchIn!
            }
        }
        semiFinals = semiFinals.sorted{a,b in
            if a.matchNumber != b.matchNumber{
                return a.matchNumber < b.matchNumber
            }else{
                return a.matchIn! < b.matchIn!
            }
        }
        finals = finals.sorted{a,b in
            if a.matchNumber != b.matchNumber{
                return a.matchNumber < b.matchNumber
            }else{
                return a.matchIn! < b.matchIn!
            }
        }
        Data.matchList = qualifyingMatches + quarterFinals + semiFinals + finals
                
    }
    
    static func getMatches(withTeam: Team) -> [TBAMatch] {
        var matches = [TBAMatch]()
        for (match) in Data.matchList {
            for (team) in match.blue {
                if (team.teamNumber == withTeam.teamNumber) {
                    matches.append(match)
                }
            }
            for (team) in match.red {
                if (team.teamNumber == withTeam.teamNumber) {
                    matches.append(match)
                }
            }
        }
        return matches
    }
    
    static func getMatch(withKey: String) -> TBAMatch? {
        for (match) in Data.matchList {
            if(match.key == withKey) {
                return match
            }
        }
        print("Match " + withKey + " does not exist")
        return nil
    }
    
    static func getTeam(withNumber: Int) -> Team? {
        for (team) in Data.teamList {
            if(team.teamNumber == withNumber) {
                return team
            }
        }
        print("Team number " + String(withNumber) + " does not exist")
        return nil
    }
    
    static func getTIMD(team: Team, match: TBAMatch) -> TIMD? {
        for (timd) in Data.timdList {
            if (timd.team.teamNumber == team.teamNumber && timd.match.key == match.key) {
                return timd
            }
        }
        print("TIMD with team " + String(team.teamNumber) + " in " + match.key + " does not exist")
        return nil
    }
//    static func sendToVC(value: NSDictionary){
//        let queryResult : NSDictionary = value.value(forKey: "query") as! NSDictionary
//        let matches : NSDictionary = queryResult.value(forKey: "matches") as! NSDictionary
//        let matchListVC = MatchListViewController()
//        for (a, b) in matches{
//            var temp : NSMutableDictionary = (b as! NSDictionary).mutableCopy() as! NSMutableDictionary
//            temp.setValue(a as! String, forKey: "config")
//            matchListVC.saveToCoreData(dict: temp)
//        }
//    }
}
