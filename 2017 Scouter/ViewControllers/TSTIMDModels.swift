//
//  TSTIMDModel.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/10/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import CoreData

class TIMD: CoreData {
    
    var team: Team
    var match: TBAMatch
    
    static var importantKeys = ""
    
    var importantStats = [String: Any]()
    var stats = [String: Any]()
    
    init(team: Team, match: TBAMatch, data: NSDictionary) {
        self.team = team
        self.match = match
        let d = data.mutableCopy() as! NSMutableDictionary
        for (key) in TIMD.importantKeys.components(separatedBy: ",") {
            importantStats[key] = data.value(forKey: key)
            d.removeObject(forKey: key)
        }
        for (key, value) in d {
            stats[key as! String] = value
        }
        super.init(entityName: "TIMDs")
    }
    
    override init(_ managedObject: NSManagedObject) {
        let unarchivedData : NSData = managedObject.value(forKey: "data") as! NSData
        do {
            let dict: NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
            let teamNumber = dict.object(forKey: "teamNumber") as! Int
            self.team = Data.getTeam(withNumber: teamNumber)!
            self.match = Data.getMatch(withKey: (dict.object(forKey: "matchKey") as! String))!
            self.importantStats = dict.object(forKey: "importantStats") as! Dictionary<String, Any>
            self.stats = dict.object(forKey: "stats") as! Dictionary<String, Any>
            super.init(managedObject)
        } catch {
            fatalError("core data fetch error")
        }
    }
    
    override func getJSON() -> NSDictionary {
        return [
            "teamNumber": self.team.teamNumber,
            "matchKey": self.match.key,
            "importantStats": self.importantStats,
            "stats": self.stats
        ]
    }
}
