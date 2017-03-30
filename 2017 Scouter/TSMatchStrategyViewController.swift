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
        
        let percent : Double = team.importantStats["End-Takeoff-Achieve-Rate"]! as! Double
        print(percent)
        retVal = "Climb: \((round(1000*percent)/10))%"
        
        var climbCount : Int = 0
        var total : Int = 0
        
        for match in team.matches {
            let timd = Data.getTIMD(team: team, match: match)
            if (timd == nil) {
                continue
            }
            
            if timd?.stats["End-Takeoff"] as! String == "2" {
                climbCount += 1
            }
            total += 1
        }
        
        retVal += "(\(climbCount) of \(total)) \n"
        // End Climb
        
        retVal += "Climb Speed: \(team.importantStats["End-Takeoff-Speed-Average"]!)\n"
        
        
        let cycle : Double = team.importantStats["Tele-Gears-Cycles-Average"]! as! Double
        retVal += "Gear Count Average: \(round(1000*cycle)/1000) \n\n"
    
        return retVal
    }
    
}
