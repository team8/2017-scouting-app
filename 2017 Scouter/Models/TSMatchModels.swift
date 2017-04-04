//
//  DataModels.swift
//  scouter
//
//  Created by Robert Selwyn on 8/25/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation
import CoreData

class TBAMatch: CoreData {
    
    var blue: [Team]
    var red: [Team]
    var key: String
    var matchNumber: Int
    var matchType: MatchType
    var matchIn: Int?
    
    var played: Bool
    
    var blueScore: Int?
    var redScore: Int?
    var blueWinChance: Int?
    var redWinChance: Int?
    var blueRotor: Int?
    var redRotor: Int?
    var blueFortyKPa: Bool?
    var redFortyKPa: Bool?
    
    enum MatchType {
        case qualifying
        case quarterFinal
        case semiFinal
        case final
        case unknown
    }
    
    func initialize(keyV: String, blueAlliance: [Team], redAlliance: [Team]) {
        self.blue = blueAlliance
        self.red = redAlliance
        self.key = keyV
        let continuedString : String = key.components(separatedBy: "_")[1]
        let arrayOfCharc = Array(continuedString.characters)
        
        if arrayOfCharc[0] == Character("q"){
            if (arrayOfCharc[1] == Character("m")){
                matchType = MatchType.qualifying
                var matchNumberString: String = String(arrayOfCharc[2])
                if arrayOfCharc.count == 4{
                    matchNumberString += String(arrayOfCharc[3])
                }
                
                matchNumber = Int(matchNumberString)!
            }else{
                matchType = MatchType.quarterFinal
                let matchNumberString: String = String(arrayOfCharc[2])
                matchNumber = Int(matchNumberString)!
                let matchInString : String = String(arrayOfCharc[4])
                matchIn = Int(matchInString)
            }
        }else if arrayOfCharc[0] == Character("s"){
            matchType = MatchType.semiFinal
            let matchNumberString: String = String(arrayOfCharc[2])
            matchNumber = Int(matchNumberString)!
            let matchInString : String = String(arrayOfCharc[4])
            matchIn = Int(matchInString)
        }else if arrayOfCharc[0] == Character("f"){
            matchType = MatchType.final
            let matchNumberString : String = String(arrayOfCharc[1])
            matchNumber = Int(matchNumberString)!
            let matchInString : String = String(arrayOfCharc[3])
            matchIn = Int(matchInString)
        }else{
            matchType = MatchType.unknown
            matchNumber = 0
        }
    }
    
    init(keyV: String, blueAlliance: [Team], redAlliance: [Team], scoreBreakdown: NSDictionary?) {
        if (scoreBreakdown == nil) {
            self.played = false
        } else {
            self.played = true
            let blueDict = scoreBreakdown!.object(forKey: "blue") as! NSDictionary
            let redDict = scoreBreakdown!.object(forKey: "red") as! NSDictionary
            self.blueScore = blueDict.object(forKey: "totalPoints") as? Int
            self.redScore = redDict.object(forKey: "totalPoints") as? Int
            
//            self.blueRotor = Int(NSNumber(value: blueDict.object(forKey: "teleopDefensesBreached") as! Bool))
//            self.redRotor = Int(NSNumber(value: redDict.object(forKey: "teleopDefensesBreached") as! Bool))
////            print(Int(NSNumber(value: blueDict.object(forKey: "teleopDefensesBreached") as! Bool)))
//            self.blueFortyKPa = blueDict.object(forKey: "teleopTowerCaptured") as? Bool
//            self.redFortyKPa = redDict.object(forKey: "teleopTowerCaptured") as? Bool
            
            self.blueRotor = Int(NSNumber(value: (blueDict.object(forKey: "rotor1Engaged") as! Bool))) + Int(NSNumber(value: (blueDict.object(forKey: "rotor2Engaged") as! Bool))) + Int(NSNumber(value: (blueDict.object(forKey: "rotor3Engaged") as! Bool))) + Int(NSNumber(value: (blueDict.object(forKey: "rotor4Engaged") as! Bool)))
            self.redRotor = Int(NSNumber(value: (redDict.object(forKey: "rotor1Engaged") as! Bool))) + Int(NSNumber(value: (redDict.object(forKey: "rotor2Engaged") as! Bool))) + Int(NSNumber(value: (redDict.object(forKey: "rotor3Engaged") as! Bool))) + Int(NSNumber(value: (redDict.object(forKey: "rotor4Engaged") as! Bool)))
            self.blueFortyKPa = blueDict.object(forKey: "kPaRankingPointAchieved") as? Bool
            self.redFortyKPa = redDict.object(forKey: "kPaRankingPointAchieved") as? Bool
        }
        self.blue = blueAlliance
        self.red = redAlliance
        self.key = keyV
        let continuedString : String = key.components(separatedBy: "_")[1]
        let arrayOfCharc = Array(continuedString.characters)
        
        if arrayOfCharc[0] == Character("q"){
            if (arrayOfCharc[1] == Character("m")){
                matchType = MatchType.qualifying
                var matchNumberString: String = String(arrayOfCharc[2])
                if arrayOfCharc.count == 4{
                    matchNumberString += String(arrayOfCharc[3])
                }
                
                matchNumber = Int(matchNumberString)!
            }else{
                matchType = MatchType.quarterFinal
                let matchNumberString: String = String(arrayOfCharc[2])
                matchNumber = Int(matchNumberString)!
                let matchInString : String = String(arrayOfCharc[4])
                matchIn = Int(matchInString)
            }
        }else if arrayOfCharc[0] == Character("s"){
            matchType = MatchType.semiFinal
            let matchNumberString: String = String(arrayOfCharc[2])
            matchNumber = Int(matchNumberString)!
            let matchInString : String = String(arrayOfCharc[4])
            matchIn = Int(matchInString)
        }else if arrayOfCharc[0] == Character("f"){
            matchType = MatchType.final
            let matchNumberString : String = String(arrayOfCharc[1])
            matchNumber = Int(matchNumberString)!
            let matchInString : String = String(arrayOfCharc[3])
            matchIn = Int(matchInString)
        }else{
            matchType = MatchType.unknown
            matchNumber = 0
        }
        super.init(entityName: "Matches")
    }
    
    override init(_ managedObject: NSManagedObject) {
        let unarchivedData : NSData = managedObject.value(forKey: "data") as! NSData
        do {
            let dict: NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
            let blueDict = dict.object(forKey: "blue") as! NSDictionary
            let redDict = dict.object(forKey: "red") as! NSDictionary
            var blue = [Team]()
            for (num) in (blueDict.object(forKey: "teams") as! [Int]) {
                blue.append(Data.getTeam(withNumber: num)!)
            }
            var red = [Team]()
            for (num) in (redDict.object(forKey: "teams") as! [Int]) {
                red.append(Data.getTeam(withNumber: num)!)
            }
            let key = dict.object(forKey: "key") as! String
            self.blue = blue
            self.red = red
            self.key = key
            let continuedString : String = key.components(separatedBy: "_")[1]
            let arrayOfCharc = Array(continuedString.characters)
            
            if arrayOfCharc[0] == Character("q"){
                if (arrayOfCharc[1] == Character("m")){
                    matchType = MatchType.qualifying
                    var matchNumberString: String = String(arrayOfCharc[2])
                    if arrayOfCharc.count == 4{
                        matchNumberString += String(arrayOfCharc[3])
                    }
                    
                    matchNumber = Int(matchNumberString)!
                }else{
                    matchType = MatchType.quarterFinal
                    let matchNumberString: String = String(arrayOfCharc[2])
                    matchNumber = Int(matchNumberString)!
                    let matchInString : String = String(arrayOfCharc[4])
                    matchIn = Int(matchInString)
                }
            }else if arrayOfCharc[0] == Character("s"){
                matchType = MatchType.semiFinal
                let matchNumberString: String = String(arrayOfCharc[2])
                matchNumber = Int(matchNumberString)!
                let matchInString : String = String(arrayOfCharc[4])
                matchIn = Int(matchInString)
            }else if arrayOfCharc[0] == Character("f"){
                matchType = MatchType.final
                let matchNumberString : String = String(arrayOfCharc[1])
                matchNumber = Int(matchNumberString)!
                let matchInString : String = String(arrayOfCharc[3])
                matchIn = Int(matchInString)
            }else{
                matchType = MatchType.unknown
                matchNumber = 0
            }
            self.played = dict.object(forKey: "played") as! Bool
            if (self.played) {
                self.blueScore = blueDict.object(forKey: "score") as? Int
                self.blueRotor = blueDict.object(forKey: "rotor") as? Int
                self.blueFortyKPa = blueDict.object(forKey: "fortyKPa") as? Bool
                self.redScore = redDict.object(forKey: "score") as? Int
                self.redRotor = redDict.object(forKey: "rotor") as? Int
                self.redFortyKPa = redDict.object(forKey: "fortyKPa") as? Bool
            }
            super.init(managedObject)

        } catch {
            fatalError("core data fetch error")
        }
    }
    
    func hasTeam(team: Team) -> Bool {
        for t in blue {
            if t.teamNumber == team.teamNumber {
                return true
            }
        }
        for t in red {
            if t.teamNumber == team.teamNumber {
                return true
            }
        }
        return false
    }
    
    override func getJSON() -> NSDictionary {
        var blue = [Int]()
        for (team) in self.blue {
            blue.append(team.teamNumber)
        }
        var red = [Int]()
        for (team) in self.red {
            red.append(team.teamNumber)
        }
        if (self.played) {
            return [
                "blue": [
                    "teams": blue,
                    "score": self.blueScore!,
                    "rotor": self.blueRotor!,
                    "fortyKPa": self.blueFortyKPa!
                ],
                "red": [
                    "teams": red,
                    "score": self.redScore!,
                    "rotor": self.redRotor!,
                    "fortyKPa": self.redFortyKPa!
                ],
                "key": self.key,
                "played": self.played
                ]
        } else {
            return [
                "blue": [
                    "teams": blue
                ],
                "red": [
                    "teams": red
                ],
                "key": self.key,
                "played": self.played
                ]
        }
    }
}
