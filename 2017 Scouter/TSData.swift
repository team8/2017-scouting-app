//
//  Data.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 12/5/16.
//  Copyright © 2016 Robbie. All rights reserved.
//

import Foundation

class Data {
    
    static var teamList = ["frc8", "frc254", "frc1678", "ym"]
    static var matchList = [TBAMatch]()
    
    static let fetchesTotal = 1
    static var fetchesComplete = 0
    static var completeFunction: (() -> Void)?
    
    static func fetch(complete: @escaping () -> Void) {
        
        ServerInterfacer.getMatches(handleMatchJSON, key: "2016cacc")
        completeFunction = complete
    }
    
    static func fetchComplete() {
        fetchesComplete += 1
        if fetchesComplete == fetchesTotal {
            completeFunction!()
            fetchesComplete = 0
        }
        


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
