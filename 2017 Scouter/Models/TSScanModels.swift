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
    
    static let keys = ["name", "comp_level", "match_number", "match_in", "team_number", "auto_baseline", "auto_robot_no_action", "auto_robot_broke_down", "auto_gears", "auto_gears_positions", "auto_gears_failed", "auto_gears_failed_positions", "auto_gears_intake_ground", "auto_fuel_high_cycles", "auto_fuel_high_positions", "auto_fuel_low_cycles", "auto_fuel_intake_hopper", "tele_robot_no_action", "tele_robot_broke_down", "tele_gears_cycles", "tele_gears_position_boiler", "tele_gears_position_middle", "tele_gears_position_loading", "tele_gears_dropped", "tele_gears_intake_ground", "tele_gears_intake_loading_station", "tele_gears_intake_dropped", "tele_gears_cycles_times", "tele_fuel_high_cycles", "tele_fuel_high_cycles_in_key", "tele_fuel_high_cycles_out_of_key", "tele_fuel_high_cycles_times", "tele_fuel_low_cycles", "tele_fuel_low_cycles_times", "tele_fuel_intake_hopper", "tele_fuel_intake_loading_station", "end_no_show", "end_takeoff", "end_takeoff_speed", "end_defense", "end_defense_rating", "end_gear_ground_intake", "end_gear_ground_intake_rating", "end_fuel_ground_intake", "end_fuel_ground_intake_rating", "end_driver_rating"]
    
    var scoringElements = [String: String]()
    
    // CSV Format
    // Index 0: Match Number
    // Index 1: Team
    // Index 2: ...
    init(from data : String) {
        var splitVersion = data.components(separatedBy: ",")
        print(splitVersion)
        for (i, key) in ScannedMatchData.keys.enumerated() {
            scoringElements[key] = splitVersion[i]
        }
        var notes = splitVersion[ScannedMatchData.keys.count]
        if(splitVersion.count > ScannedMatchData.keys.count + 2) {
            for i in (ScannedMatchData.keys.count + 1)..<splitVersion.count-1 {
                notes += "," + splitVersion[i]
            }
        }
        scoringElements["end_notes"] = notes
        scoringElements["event"] = splitVersion[splitVersion.count-1]
    }
    
    
}
