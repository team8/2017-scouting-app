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
    
    var matches = [TBAMatch]()
    
    //Stats
    static let importantKeys = ["improtant!!11!1"]
    var importantStats = [String: Any]()
    var otherStats = [String: Any]()
    
    init(teamNumber: Int) {
        self.teamNumber = teamNumber
        self.key = "frc" + String(teamNumber)
        super.init(entityName: "Teams")
    }
    
    //Init from Core Data
    override init(_ managedObject: NSManagedObject) {
        let unarchivedData : NSData = managedObject.value(forKey: "data") as! NSData
        do {
            let dict: NSDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as! NSDictionary
            self.teamNumber = dict.value(forKey: "teamNumber") as! Int
            self.key = "frc" + String(self.teamNumber)
            self.importantStats = dict.value(forKey: "importantStats") as! Dictionary<String, Any>
            self.otherStats = dict.value(forKey: "otherStats") as! Dictionary<String, Any>
            super.init(managedObject)
            
        } catch {
            fatalError("core data fetch error")
        }
    }
    
    func setFirebaseData(data: NSDictionary) {
        let d = data.mutableCopy() as! NSMutableDictionary
        for (key) in Team.importantKeys {
            importantStats[key] = data.value(forKey: key)
            d.removeObject(forKey: key)
        }
        for (key, value) in d {
            otherStats[key as! String] = value
        }
    }
    
    override func getJSON() -> NSDictionary {
        return [
            "teamNumber": self.teamNumber,
            "importantStats": self.importantStats,
            "otherStats": self.otherStats
        ]
    }
}
