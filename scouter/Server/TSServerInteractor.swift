//
//  TSServerInteractor.swift
//  scouter
//
//  Created by Robert Selwyn on 8/20/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation
import Alamofire

class ServerInterfacer {
    
    // This can be public because it can be changed so easily
    static let AUTH_TOKEN = "R0yMFRkeaaHPlWWkf73W00C88pHYNVNeFXPrsO8N"
    static let SERVER_ADDRESS = "http://server.palyrobotics.com:5000"
    
    static let MAX_WAIT_TIME : Int = 300
    
    static func testConnection(callback: (Bool) -> Void) -> Void {
        
        Alamofire.request(.GET, SERVER_ADDRESS + "/test/" + AUTH_TOKEN, encoding: .JSON)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let raw_val = JSON as! NSDictionary
                    let shouldReturnVal = raw_val.objectForKey("connection")
//                    print("JSON: \(JSON)")
                    print(shouldReturnVal as! String)
                    if shouldReturnVal as! String == "success"{
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                }
                else {
                    callback(false)
                }
        }
    }
    
}