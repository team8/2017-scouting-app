//
//  TSScanModels.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 12/20/16.
//  Copyright © 2016 Team 8. All rights reserved.
//

import Foundation
import UIKit

/*
 The data is transfered to this class in the format of CSV.
 */
class ScannedMatchData {
    
    static let CURRENT_DATA_ELEMENTS_NUMBER : Int = 22
    
    var scoringElements = [String: String]()
    
    // CSV Format
    // Index 0: Match Number
    // Index 1: Team
    // Index 2: ...
    init(from data : String) {
        var splitVersion = data.components(separatedBy: ",")
        print(splitVersion)
        scoringElements["match"] = splitVersion[0]
        scoringElements["team"] = splitVersion[1]
        scoringElements["comp_level"] = "qm"
        scoringElements["auto_baseline"] = splitVersion[2]
        scoringElements["auto_gears"] = splitVersion[3]
        scoringElements["auto_gear_positions"] = splitVersion[4]
        scoringElements["auto_gears_dropped"] = splitVersion[5]
        scoringElements["auto_high_fuel"] = splitVersion[6]
        scoringElements["auto_high_fuel_positions"] = splitVersion[7]
        scoringElements["auto_low_cycles"] = splitVersion[8]
        scoringElements["auto_intake_hopper"] = splitVersion[9]
        scoringElements["tele_gears"] = splitVersion[10]
        scoringElements["tele_gear_positions"] = splitVersion[11]
        scoringElements["tele_gears_dropped"] = splitVersion[12]
        scoringElements["tele_high_fuel"] = splitVersion[13]
        scoringElements["tele_high_fuel_positions"] = splitVersion[14]
        scoringElements["tele_low_cycles"] = splitVersion[15]
        scoringElements["tele_intake_hopper"] = splitVersion[16]
        scoringElements["tele_intake_loading"] = splitVersion[17]
        scoringElements["tele_defense"] = splitVersion[18]
        scoringElements["end_climb"] = splitVersion[19]
        scoringElements["end_ground_intake_gear"] = splitVersion[20]
        scoringElements["end_ground_intake_fuel"] = splitVersion[21]
        scoringElements["end_stop_gearing"] = splitVersion[21]
        scoringElements["end_fouls"] = splitVersion[22]
    }
    
    
}
