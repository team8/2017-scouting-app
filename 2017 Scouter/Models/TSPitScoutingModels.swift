//
//  TSPitScoutingModels.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/14/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import CoreData

class PitScouting: CoreData {

    var teamNumber: Int?
    
    var stats = [String: String]()
    
    init(local: Bool) {
        if(local) {
            super.init(entityName: "PitScoutingEntity")
        } else {
            super.init(entityName: "FirebasePitScoutingEntity")
        }
    }
    
//    init(teamNumber: Int) {
//        self.teamNumber = teamNumber
//        super.init(entityName: "PitScoutingEntity")
//    }
    
    init(teamNumber: Int, data: NSDictionary, local: Bool) {
        self.stats = data as! [String : String]
        self.teamNumber = teamNumber
        if(local) {
            super.init(entityName: "PitScoutingEntity")
        } else {
            super.init(entityName: "FirebasePitScoutingEntity")
        }
    }
    
    override init(_ managedObject: NSManagedObject) {
        let unarchivedData : NSData = managedObject.value(forKey: "data") as! NSData
        do {
            let dict: NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
            self.teamNumber = dict.object(forKey: "teamNumber") as? Int
            self.stats = dict.object(forKey: "stats") as! Dictionary <String, String>
            super.init(managedObject)
        } catch {
            fatalError("core data fetch error")
        }
    }
    
    override func getJSON() -> NSDictionary {
        return [
            "teamNumber": self.teamNumber!,
            "stats": self.stats
        ]
    }
}
