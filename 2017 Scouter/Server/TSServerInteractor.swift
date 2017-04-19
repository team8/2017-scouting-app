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
    static let AUTH_TOKEN = "roebling"
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
    
    static func sendBug(data: String, callback: @escaping (Bool) -> Void ) -> Void {
        
        let headers = ["issue" : data]
        print(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/error/")
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/error", headers: headers)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let raw_val = JSON as! NSDictionary
                    let shouldReturnVal = raw_val.object(forKey: "report")
                    
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
        print("[Server Interactor] Retrieving matches for event " + key)
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/match/" + key, headers: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("[Server Interactor] Successfully retrieved matches for event " + key)
                    print("JSON: \(JSON)")
                    let rawVal = JSON as! NSDictionary
                    callback(rawVal)
                }
                else if let status = response.result.error?._code {
                    print(response)
                    switch(status){
                    case -1009:
                        print("[Server Interactor] Error retrieving matches for event " + key + ": The Internet connection appears to be offline.")
                    default:
                        print("[Server Interactor] Error parsing server response, please make sure the server is running.")
                    }
                    callback(["query": ["success": "no"]])
                } else {
                    print(response)
                    print("[Server Interactor] Error parsing server response, please make sure the server is running.")
                    callback(["query": ["success": "no"]])
                }
        }
    }
    
    static func getTeams(_ callback: @escaping (NSDictionary) -> Void, key : String) -> Void {
        print("[Server Interactor] Retrieving teams for event " + key)
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/teams/" + key, headers: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("[Server Interactor] Successfully retrieved teams for event " + key)
//                    print("JSON: \(JSON)")
                    let rawVal = JSON as! NSDictionary
                    callback(rawVal)
                }
                else if let status = response.result.error?._code {
                    print(response)
                    switch(status){
                    case -1009:
                        print("[Server Interactor] Error retrieving teams for event " + key + ": The Internet connection appears to be offline.")
                    default:
                        print("[Server Interactor] Error parsing server response, please make sure the server is running.")
                    }
                    callback(["query": ["success": "no"]])
                } else {
                    print(response)
                    print("[Server Interactor] Error parsing server response, please make sure the server is running.")
                    callback(["query": ["success": "no"]])
                }
        }
    }
    
    static func uploadData(with data: [String: String], callback: @escaping (Bool) -> Void) -> Void {
        let headers = data
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/upload_data", headers: headers)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let raw_val = JSON as! NSDictionary
                    let shouldReturnVal = raw_val.object(forKey: "status")
                    
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
    
    static func uploadPitData(with data: [String: String], callback: @escaping (Bool) -> Void) -> Void {
        let headers = data
        Alamofire.request(SERVER_ADDRESS + "/" + AUTH_TOKEN + "/upload_pit_data", headers: headers)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let raw_val = JSON as! NSDictionary
                    let shouldReturnVal = raw_val.object(forKey: "status")
                    
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
