//
//  TSTeamModels.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/2/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation

class Team {
    
    var key : String
    var teamNumber : Int
    
    var matches = [TBAMatch]()
    
    //Stats
//    var importantStats = [String: Any]()
//    var otherStats = [String: Any]()
    var importantStats = ["ym1": 0, "ym2": "hi", "ym3": true, "ym4": 2, "ym5": 3] as [String : Any]
    var otherStats = ["ym6": 0, "ym7": "hi", "ym8": true, "ym9": 2, "ym10": 3] as [String: Any]
    
    init(teamNumber: Int) {
        self.teamNumber = teamNumber
        self.key = "frc" + String(teamNumber)
        fetchFirebaseData()
    }
    
    func fetchFirebaseData() {
        
    }
}
