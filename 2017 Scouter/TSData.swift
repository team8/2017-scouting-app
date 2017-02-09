//
//  Data.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation

class Data {
    
    static var competition: String?
    
    static var teamList = [Team]()
    static var matchList = [TBAMatch]()
    
    static let fetchesTotal = 2
    static var fetchesComplete = 0
    static var completeFunction: (() -> Void)?
    
    static func fetch(complete: @escaping () -> Void) {
        
//        ServerInterfacer.getTeams(handleTeamJSON, key: Data.competition!)
        ServerInterfacer.getTeams(handleTeamJSON, key: "2016casj")
        //        ServerInterfacer.getMatches(handleMatchJSON, key: Data.competition!)
        ServerInterfacer.getMatches(handleMatchJSON, key: "2016casj")
        completeFunction = complete
    }
    
    static func finishFetch() {
        
    }
    
    static func fetchComplete() {
        fetchesComplete += 1
        if fetchesComplete == fetchesTotal {
            finishFetch()
            completeFunction!()
            fetchesComplete = 0
        }
    }
    
    static func handleTeamJSON(value: NSDictionary) -> Void {
        if (((value.value(forKey: "query") as! NSDictionary).value(forKey: "success"))! as! String == "yes") {
            teamList.removeAll()
            for (_, value) in (value.value(forKey: "query") as! NSDictionary).value(forKey: "teams") as! NSDictionary {
                let payloadDict = value as! NSDictionary
                
                let teamNumber = payloadDict.object(forKey: "team_number") as! Int
                let team = Team(teamNumber: teamNumber)
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
            matchList.removeAll()
//            print(value)
//            let matchListVC = MatchListViewController()
//            matchListVC.deleteAllData()
            
//            sendToVC(value: value)

            while(Data.teamList.count == 0){print("hi")}
            
            for (key, value) in (value.value(forKey: "query") as! NSDictionary).value(forKey: "matches") as! NSDictionary {
//                print(key)
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
                matchList.append(TBAMatch(keyV: name, blueAlliance: blue, redAlliance: red, scoreBreakdown: scoreBreakdown))
                
            }
            
            Data.orderMatches()
            
            //Populate teams with matches
            for (team) in Data.teamList {
                team.matches = Data.getMatches(withTeam: team)
            }
        }
        else {
            print(value)
        }
        
        fetchComplete()

        
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
    
    static func getTeam(withNumber: Int) -> Team? {
        for (team) in Data.teamList {
            if(team.teamNumber == withNumber) {
                return team
            }
        }
        print("Team number " + String(withNumber) + " does not exist")
        for (team) in Data.teamList {
            print(team.teamNumber)
        }
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
