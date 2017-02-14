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
    
    var stats = [String: Any]()
    
    init(team: Team, match: TBAMatch, data: NSDictionary) {
        self.team = team
        self.match = match
        for (key, value) in data {
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
            "stats": self.stats
        ]
    }
}
