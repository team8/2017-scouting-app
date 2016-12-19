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
//    static let AUTH_TOKEN = "R0yMFRkeaaHPlWWkf73W00C88pHYNVNeFXPrsO8N"
    static let AUTH_TOKEN = "password"
    static let SERVER_ADDRESS = "http://server.palyrobotics.com:5000"
    
    static func testConnection(_ callback: @escaping (Bool) -> Void) -> Void {
        
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/test/", headers: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let raw_val = JSON as! NSDictionary
                    let shouldReturnVal = raw_val.object(forKey: "connection")
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
    
    static func getMatches(_ callback: @escaping (NSDictionary) -> Void, key : String) -> Void {
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/match/" + key, headers: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let rawVal = JSON as! NSDictionary
                    callback(rawVal)
                }
                else {
                    print(response)
                    print("[ERROR] Error parsing server response, please make sure the server is running.")
                    callback(["query": ["success": "no"]])
                }
        }
    }
    
}