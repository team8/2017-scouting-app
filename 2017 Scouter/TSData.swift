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
    
    static var teamList = [Int]()
    static var matchList = [TBAMatch]()
    
    static let fetchesTotal = 2
    static var fetchesComplete = 0
    static var completeFunction: (() -> Void)?
    
    static func fetch(complete: @escaping () -> Void) {
        
        ServerInterfacer.getTeams(handleTeamJSON, key: Data.competition!)
        ServerInterfacer.getMatches(handleMatchJSON, key: Data.competition!)
        completeFunction = complete
    }
    
    static func fetchComplete() {
        fetchesComplete += 1
        if fetchesComplete == fetchesTotal {
            completeFunction!()
            fetchesComplete = 0
        }
        


    }
    
    static func handleTeamJSON(value: NSDictionary) -> Void {
        if (((value.value(forKey: "query") as! NSDictionary).value(forKey: "success"))! as! String == "yes") {
            for (key, value) in (value.value(forKey: "query") as! NSDictionary).value(forKey: "teams") as! NSDictionary {
                let payloadDict = value as! NSDictionary
                
                let teamNumber = payloadDict.object(forKey: "team_number") as! Int
                teamList.append(teamNumber)
                
            }
//            print(teamList)
        } else {
            print(value)
        }
        fetchComplete()
    }
    
    static func handleMatchJSON(value: NSDictionary) -> Void {
        if (((value.value(forKey: "query") as! NSDictionary).value(forKey: "success"))! as! String == "yes") {
            
            let matchListVC = MatchListViewController()
            matchListVC.deleteAllData()
            
            sendToVC(value: value)

            for (key, value) in (value.value(forKey: "query") as! NSDictionary).value(forKey: "matches") as! NSDictionary {
                print(key)
                let name = key as! String
                
                let payloadDict = value as! NSDictionary
                
                let blue = payloadDict.object(forKey: "blue") as! [String]
                let red = payloadDict.object(forKey: "red") as! [String]
                matchList.append(TBAMatch(keyV: name, blueAlliance: blue, redAlliance: red))

                
                
            }
        }
        else {
            print(value)
        }
        
        fetchComplete()

        
    }
    static func sendToVC(value: NSDictionary){
        let queryResult : NSDictionary = value.value(forKey: "query") as! NSDictionary
        let matches : NSDictionary = queryResult.value(forKey: "matches") as! NSDictionary
        let matchListVC = MatchListViewController()
        for (a, b) in matches{
            var temp : NSMutableDictionary = (b as! NSDictionary).mutableCopy() as! NSMutableDictionary
            temp.setValue(a as! String, forKey: "config")
            matchListVC.saveToCoreData(dict: temp)
        }
    }
}
