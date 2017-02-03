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
    var importantStats = [String: Any]()
    var otherStats = [String: Any]()
    
    init(teamNumber: Int) {
        self.teamNumber = teamNumber
        self.key = "frc" + String(teamNumber)
        fetchFirebaseData()
    }
    
    func fetchFirebaseData() {
        
    }
}
