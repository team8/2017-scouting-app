//
//  TSMatchStrategyViewController.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 3/28/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import UIKit

class MatchStrategyViewController : ViewController {
    
    static var match : TBAMatch?
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var red: UITextView!
    
    @IBOutlet weak var blue: UITextView!
    
    override func viewDidLoad() {
        titleText.text = MatchStrategyViewController.match?.key.replacingOccurrences(of: "2017", with: "")
        red.isScrollEnabled = true
        blue.isScrollEnabled = true
        red.isEditable = false
        blue.isEditable = false
        
        blue.text = ""
        red.text = ""
        
        for team in (MatchStrategyViewController.match?.blue)! {
            blue.text = blue.text + "Team #\(team.teamNumber)\n\n"
            blue.text = blue.text + getData(team: team)
        }

        for team in (MatchStrategyViewController.match?.red)! {
            red.text = red.text + "Team #\(team.teamNumber)\n\n"
            red.text = red.text + getData(team: team)
        }
    }
    
    func getData(team : Team) -> String{
        var retVal : String = ""
        
        // Begin Climb
        
        print(team.teamNumber)
        print(team.importantStats)
        print(team.otherStats)
        let percent : String = team.importantStats["End-Takeoff-Achieve-Rate"]! as! String
        print(percent)
//        retVal = "Climb: \((round(1000*percent)/10))%"
        retVal = "Climb: " + percent + "\n"
        
        var climbCount : Int = 0
        var total : Int = 0
        
        var gearString = "Gears Delivered: "
        
        var notes = "Notes:\n\n"
        
//        It was changed so that the server calculated the end-takeoff success counts
//        This is here only for completeness
        for match in team.matches {
            let timd = Data.getTIMD(team: team, match: match)
            if (timd == nil || timd?.stats.count == 0) {
                continue
            }
            
            if timd?.stats["End-Takeoff"] as! String == "2" {
                climbCount += 1
            }
            
            gearString += timd?.stats["Tele-Gears-Cycles"] as! String + ", "
            
            total += 1
            
            if timd?.stats["End-Notes"] != nil && timd?.stats["End-Notes"] as! String != "" {
                notes += "QM \(match.matchNumber): "
                notes += timd?.stats["End-Notes"] as! String + "\n"
            }
        }
        
//        retVal += "(\(climbCount) of \(total)) \n"
        // End Climb
        
        retVal += "Climb Speed: \(team.importantStats["End-Takeoff-Speed-Average"]!)\n"
        
        
        let cycle : Double = team.importantStats["Tele-Gears-Cycles-Average"]! as! Double
        retVal += "Gear Count Average: \(round(1000*cycle)/1000) \n"
        retVal += gearString + "\n"
        
        var rotorString = "Rotors Spinning: "
        
        for match in team.matches {
            
            if !match.played {
                continue
            }
            
            if (match.blue[0].teamNumber == team.teamNumber || match.blue[1].teamNumber == team.teamNumber || match.blue[2].teamNumber == team.teamNumber) {
                rotorString += "\(match.blueRotor!), "
            }
            else {
                rotorString += "\(match.redRotor!), "
            }
        }
        
        retVal += rotorString + "\n\n"
        
        retVal += "Auto: \n"
        retVal += "Overall Rate: \(team.otherStats["Auto-Gears-Achieve-Rate"]!)\n"
        
        var centerCount = 0
        var boilerCount = 0
        var loadingCount = 0
        
        var centerFail = 0
        var boilerFail = 0
        var loadingFail = 0
        
        for match in team.matches {
            let timd = Data.getTIMD(team: team, match: match)
            
            if (timd == nil) {
                continue
            }
            
            if ((timd?.stats["Auto-Gears-Positions"] as! String).contains("b")){
                boilerCount += 1
            }
            if ((timd?.stats["Auto-Gears-Positions"] as! String).contains("l")){
                loadingCount += 1
            }
            if ((timd?.stats["Auto-Gears-Positions"] as! String).contains("m")){
                centerCount += 1
            }
            
            if ((timd?.stats["Auto-Gears-Failed-Positions"] as! String).contains("b")){
                boilerFail += 1
            }
            if ((timd?.stats["Auto-Gears-Failed-Positions"] as! String).contains("l")){
                loadingFail += 1
            }
            if ((timd?.stats["Auto-Gears-Failed-Positions"] as! String).contains("m")){
                centerFail += 1
            }
        }
        
        // Ternary operator used to prevent ZDE
        let roundCenter = 100 * ((centerCount + centerFail) == 0 ? 0 : Double(round(100*Double(centerCount/(centerCount + centerFail)))/100))
        
        
        let roundSide = 100 * ((boilerCount + boilerFail + loadingFail + loadingCount) == 0 ? 0 : Double(round(100*Double((boilerCount + loadingCount)/(boilerCount + boilerFail + loadingFail + loadingCount)))/100))
        
        retVal += "Center Peg: \(centerCount) in \(centerCount+centerFail) attempts (\(roundCenter)%) \n"
        
        retVal += "Side Peg: \(boilerCount + loadingCount) in \(boilerCount + loadingCount + loadingFail + boilerFail) attempts (\(roundSide)%) \n"
        
        retVal += notes
        
        return retVal + "\n\n"
    }
    
}
