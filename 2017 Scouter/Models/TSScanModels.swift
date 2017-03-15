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
    
    static let CURRENT_DATA_ELEMENTS_NUMBER : Int = 46
    
    var scoringElements = [String: String]()
    
    // CSV Format
    // Index 0: Match Number
    // Index 1: Team
    // Index 2: ...
    init(from data : String) {
        var splitVersion = data.components(separatedBy: ",")
        print(splitVersion)
        scoringElements["name"] = splitVersion[0]
        scoringElements["comp_level"] = splitVersion[1]
        scoringElements["match_number"] = splitVersion[2]
        scoringElements["match_in"] = splitVersion[3]
        scoringElements["team_number"] = splitVersion[4]
        scoringElements["auto_baseline"] = splitVersion[5]
        scoringElements["auto_robot_no_action"] = splitVersion[6]
        scoringElements["auto_robot_broke_down"] = splitVersion[7]
        scoringElements["auto_gears"] = splitVersion[8]
        scoringElements["auto_gears_positions"] = splitVersion[9]
        scoringElements["auto_gears_dropped"] = splitVersion[10]
        scoringElements["auto_gears_intake_ground"] = splitVersion[11]
        scoringElements["auto_fuel_high_cycles"] = splitVersion[12]
        scoringElements["auto_fuel_high_positions"] = splitVersion[13]
        scoringElements["auto_fuel_low_cycles"] = splitVersion[14]
        scoringElements["auto_fuel_intake_hopper"] = splitVersion[15]
        scoringElements["tele_robot_no_action"] = splitVersion[16]
        scoringElements["tele_robot_broke_down"] = splitVersion[17]
        scoringElements["tele_gears_cycles"] = splitVersion[18]
        scoringElements["tele_gears_position_boiler"] = splitVersion[19]
        scoringElements["tele_gears_position_middle"] = splitVersion[20]
        scoringElements["tele_gears_position_loading"] = splitVersion[21]
        scoringElements["tele_gears_dropped"] = splitVersion[22]
        scoringElements["tele_gears_intake_ground"] = splitVersion[23]
        scoringElements["tele_gears_intake_loading_station"] = splitVersion[24]
        scoringElements["tele_gears_intake_dropped"] = splitVersion[25]
        scoringElements["tele_gears_cycles_times"] = splitVersion[26]
        scoringElements["tele_fuel_high_cycles"] = splitVersion[27]
        scoringElements["tele_fuel_high_cycles_in_key"] = splitVersion[28]
        scoringElements["tele_fuel_high_cycles_out_of_key"] = splitVersion[29]
        scoringElements["tele_fuel_high_cycles_times"] = splitVersion[30]
        scoringElements["tele_fuel_low_cycles"] = splitVersion[31]
        scoringElements["tele_fuel_low_cycles_times"] = splitVersion[32]
        scoringElements["tele_fuel_intake_hopper"] = splitVersion[33]
        scoringElements["tele_fuel_intake_loading_station"] = splitVersion[34]
        scoringElements["end_no_show"] = splitVersion[35]
        scoringElements["end_takeoff"] = splitVersion[36]
        scoringElements["end_takeoff_speed"] = splitVersion[37]
        scoringElements["end_defense"] = splitVersion[38]
        scoringElements["end_defense_rating"] = splitVersion[39]
        scoringElements["end_gear_ground_intake"] = splitVersion[40]
        scoringElements["end_gear_ground_intake_rating"] = splitVersion[41]
        scoringElements["end_fuel_ground_intake"] = splitVersion[42]
        scoringElements["end_fuel_ground_intake_rating"] = splitVersion[43]
        scoringElements["end_driver_rating"] = splitVersion[44]
        var notes = splitVersion[45]
        if(splitVersion.count > 47) {
            for i in 46..<splitVersion.count-1 {
                notes += "," + splitVersion[i]
            }
        }
        scoringElements["end_notes"] = notes
        scoringElements["event"] = splitVersion[splitVersion.count-1]
    }
    
    
}
