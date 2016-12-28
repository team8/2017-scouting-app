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
    var matchNumber : Int
    var matchType : MatchType
    var matchIn: Int?
    
    public static var matchListUnordered  = [TBAMatch]()
    
    enum MatchType {
        case qualifying
        case quarterFinal
        case semiFinal
        case final
        case unknown
    }
    
    init(keyV: String, blueAlliance : [String], redAlliance : [String]) {
        
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
                print(arrayOfCharc)
//                matchNumberString += String(arrayOfCharc[3])
                
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
    
    
    public static func orderMatches() -> [TBAMatch]{
        var qualifyingMatches = [TBAMatch]()
        var quarterFinals = [TBAMatch]()
        var semiFinals = [TBAMatch]()
        var finals = [TBAMatch]()
        var unknowns = [TBAMatch]()
        
        for matchToAssign : TBAMatch in matchListUnordered{
            switch matchToAssign.matchType {
            case MatchType.qualifying:
                qualifyingMatches.append(matchToAssign)
            case MatchType.quarterFinal:
                quarterFinals.append(matchToAssign)
            case MatchType.semiFinal:
                semiFinals.append(matchToAssign)
            case MatchType.final:
                
                finals.append(matchToAssign)
            default:
                unknowns.append(matchToAssign)
            }
        }
        
        qualifyingMatches = qualifyingMatches.sorted{ return $0.matchNumber < $1.matchNumber}
        quarterFinals = quarterFinals.sorted{a,b in
            if a.matchNumber != b.matchNumber{
                return a.matchNumber < b.matchNumber
            }else{
                return a.matchIn! < b.matchIn!
            }
        }
        semiFinals = semiFinals.sorted{a,b in
            if a.matchNumber != b.matchNumber{
                return a.matchNumber < b.matchNumber
            }else{
                return a.matchIn! < b.matchIn!
            }
        }
        finals = finals.sorted{a,b in
            if a.matchNumber != b.matchNumber{
                return a.matchNumber < b.matchNumber
            }else{
                return a.matchIn! < b.matchIn!
            }
        }
        var fullArray = qualifyingMatches + quarterFinals + semiFinals + finals
        print(fullArray[fullArray.count - 1].key)
        return fullArray
        
    }
    
}
