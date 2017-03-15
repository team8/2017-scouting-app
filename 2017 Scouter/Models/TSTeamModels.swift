//
//  TSTeamModels.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/2/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import CoreData

class Team: CoreData {
    
    var key: String
    var teamNumber: Int
    
    var ranking: Int?
    var rankingInfo: String?
    
    var matches = [TBAMatch]()
    
    //Stats
    static var importantKeys = "improtant-improtant-improtant-improtant"
    static var rankedStats = ""
    var importantStats = [String: Any]()
    var otherStats = [String: Any]()
    
    init(teamNumber: Int, ranking: Int?, rankingInfo: String?) {
        self.teamNumber = teamNumber
        self.key = "frc" + String(teamNumber)
        if let rank = ranking {
            self.ranking = rank
            self.rankingInfo = rankingInfo!
        }
        super.init(entityName: "Teams")
    }
    
    //Init from Core Data
    override init(_ managedObject: NSManagedObject) {
        let unarchivedData : NSData = managedObject.value(forKey: "data") as! NSData
        do {
            let dict: NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
            self.teamNumber = dict.value(forKey: "teamNumber") as! Int
            self.key = "frc" + String(self.teamNumber)
            if let ranking = dict.value(forKey: "ranking") {
                self.ranking = ranking as? Int
            }
            if let rankingInfo = dict.value(forKey: "rankingInfo") {
                self.rankingInfo = rankingInfo as? String
            }
            self.importantStats = dict.value(forKey: "importantStats") as! Dictionary<String, Any>
            self.otherStats = dict.value(forKey: "otherStats") as! Dictionary<String, Any>
            super.init(managedObject)
            
        } catch {
            fatalError("core data fetch error")
        }
    }
    
    func setFirebaseData(data: NSDictionary) {
        let d = data.mutableCopy() as! NSMutableDictionary
        for (key) in Team.importantKeys.components(separatedBy: ",") {
            importantStats[key] = data.value(forKey: key)
            d.removeObject(forKey: key)
        }
        for (key, value) in d {
            otherStats[key as! String] = value
        }
    }
    
    override func getJSON() -> NSDictionary {
        if let ranking = self.ranking {
            return [
                "teamNumber": self.teamNumber,
                "ranking": ranking,
                "rankingInfo": self.rankingInfo!,
                "importantStats": self.importantStats,
                "otherStats": self.otherStats
            ]
        } else {
            return [
                "teamNumber": self.teamNumber,
                "importantStats": self.importantStats,
                "otherStats": self.otherStats
            ]
        }
    }
}
