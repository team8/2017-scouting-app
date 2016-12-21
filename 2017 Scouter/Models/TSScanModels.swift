//
//  TSScanModels.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 12/20/16.
//  Copyright © 2016 Team 8. All rights reserved.
//

import Foundation

/*
 The data is transfered to this class in the format of CSV.
 */
class ScannedMatchData {
    
    var match_number : Int
    var team : String
    
    // CSV Format
    // Index 0: Match Number
    // Index 1: Team
    // Index 2: ...
    init(from data : String) {
        var splitVersion = data.components(separatedBy: ",")
//            match_number = Int(splitVersion[0])!
        if splitVersion.count == 3 {
            match_number = Int(splitVersion[0])!
            team = splitVersion[1]
        }
        else {
            match_number = 0
            team = "Error"
        }
        
    }
    
    
}
