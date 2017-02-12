//
//  TSTIMDModel.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/10/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation

class TIMD {
    
    var team: Team
    var match: TBAMatch
    
    var stats = [String: Any]()
    
    init(team: Team, match: TBAMatch, data: NSDictionary) {
        self.team = team
        self.match = match
        for (key, value) in data {
            stats[key as! String] = value
        }
    }
    
    
}
