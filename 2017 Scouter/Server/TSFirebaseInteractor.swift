//
//  TSFirebaseInteractor.swift
//  2017 Scouter
//
//  Created by Alex Tarng on 2/10/17.
//  Copyright © 2017 Team 8. All rights reserved.
//

import Foundation
import Firebase

class FirebaseInteractor {
    
    static let ref = FIRDatabase.database().reference()
    
    static func getFirebaseData(_ callback: @escaping (NSDictionary) -> Void, forKey: String) {
        ref.child(forKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let JSON = snapshot.value as! Dictionary<String, Any>
            let success = ["success": "yes"] as NSMutableDictionary
            let retVal = ["query": success] as NSMutableDictionary
//            let retVal = ["query": ["success": "yes"]] as NSDictionary
//            retVal.val
//            let query = (retVal.value(forKey: "query") as! NSDictionary).mu as! NSMutableDictionary
//            query.setObject(JSON, forKey: "teams" as NSCopying)
            (retVal["query"] as! NSMutableDictionary)["teams"] = JSON
            print(retVal)
            callback(NSDictionary(dictionary: retVal))
//            callback(retVal)
        }) { (error) in
            print(error.localizedDescription)
            print("[ERROR] Error getting value from Firebase")
            callback(["query": ["success": "no"]])
        }
    }
    
    static func setValue(forKey: String, value: Any) {
        ref.child(forKey).setValue(value)
    }
}
