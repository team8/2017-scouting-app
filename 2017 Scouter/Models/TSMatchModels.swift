//
//  DataModels.swift
//  scouter
//
//  Created by Robert Selwyn on 8/25/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation

class TBAMatch {
    
    var blue : [Team]
    var red : [Team]
    var key : String
    var matchNumber : Int
    var matchType : MatchType
    var matchIn: Int?
    
    enum MatchType {
        case qualifying
        case quarterFinal
        case semiFinal
        case final
        case unknown
    }
    
    init(keyV: String, blueAlliance : [Team], redAlliance : [Team]) {
        
        self.blue = blueAlliance
        self.red = redAlliance
        self.key = keyV
        let continuedString : String = key.components(separatedBy: "_")[1]
        let arrayOfCharc = Array(continuedString.characters) as! [Character]
        
        if arrayOfCharc[0] == Character("q"){
            if (arrayOfCharc[1] == Character("m")){
                matchType = MatchType.qualifying
                var matchNumberString: String = String(arrayOfCharc[2])
                if arrayOfCharc.count == 4{
                    matchNumberString += String(arrayOfCharc[3])
                }
                
                matchNumber = Int(matchNumberString)!
            }else{
                matchType = MatchType.quarterFinal
                let matchNumberString: String = String(arrayOfCharc[2])
                matchNumber = Int(matchNumberString)!
                let matchInString : String = String(arrayOfCharc[4])
                matchIn = Int(matchInString)
            }
        }else if arrayOfCharc[0] == Character("s"){
            matchType = MatchType.semiFinal
            let matchNumberString: String = String(arrayOfCharc[2])
            matchNumber = Int(matchNumberString)!
            let matchInString : String = String(arrayOfCharc[4])
            matchIn = Int(matchInString)
        }else if arrayOfCharc[0] == Character("f"){
            matchType = MatchType.final
            var matchNumberString : String = String(arrayOfCharc[1])
            matchNumber = Int(matchNumberString)!
            let matchInString : String = String(arrayOfCharc[3])
            matchIn = Int(matchInString)
        }else{
            matchType = MatchType.unknown
            matchNumber = 0
        }
        
    }
}
