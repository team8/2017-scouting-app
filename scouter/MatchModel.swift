//
//  DataModels.swift
//  scouter
//
//  Created by Robert Selwyn on 8/25/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation

class TBAMatch {
    
    var blue : [String]
    var red : [String]
    var key : String
    
    enum MatchType {
        case QUALIFYING
        case QUARTER_FINAL
        case SEMI_FINAL
        case FINAL
    }
    
    init(keyV: String, blueAlliance : [String], redAlliance : [String]) {
        self.blue = blueAlliance
        self.red = redAlliance
        self.key = keyV
    }
    
    func getKeyAsDisplayable() -> String {
        return self.key.componentsSeparatedByString("_")[1]
    }
    
}