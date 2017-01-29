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
    
    static let CURRENT_DATA_ELEMENTS_NUMBER : Int = 2
    
    var scoringElements = [String: String]()
    
    // CSV Format
    // Index 0: Match Number
    // Index 1: Team
    // Index 2: ...
    init(from data : String) {
        var splitVersion = data.components(separatedBy: ",")
        scoringElements["match"] = splitVersion[0]
        scoringElements["team"] = splitVersion[1]
    }
    
    
}
