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
    
    static func testConnection() {
        Alamofire.request(.GET, SERVER_ADDRESS + "/test/" + AUTH_TOKEN, encoding: .JSON)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
}