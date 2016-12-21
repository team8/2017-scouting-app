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
        case qualifying
        case quarter_FINAL
        case semi_FINAL
        case final
    }
    
    init(keyV: String, blueAlliance : [String], redAlliance : [String]) {
        self.blue = blueAlliance
        self.red = redAlliance
        self.key = keyV
    }
    
    
    func getKeyAsDisplayable() -> String {
        
        let continuedString : String = key.components(separatedBy: "_")[1]
        
        
        if continuedString[continuedString.startIndex] == Character("q") {
            if continuedString[continuedString.characters.index(continuedString.startIndex, offsetBy: 1)] == Character("m") {
                return "Qualifying Match #: \(continuedString.components(separatedBy: "qm")[1])"
            }
            else {
                return "Quarter Final Match #: \(continuedString.components(separatedBy: "qf")[1])"
            }
        }
        
        if continuedString[continuedString.startIndex] == Character("s") {
            if continuedString[continuedString.characters.index(continuedString.startIndex, offsetBy: 1)] == Character("f") {
                return "Semi Final #: \(continuedString.components(separatedBy: "sf")[1])"
            }
        }
        
        return "Unknown match with string \(self.key)"
        
    }
    
}
