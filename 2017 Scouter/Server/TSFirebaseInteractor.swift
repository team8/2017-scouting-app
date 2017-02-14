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
            if (snapshot.value is NSNull) {
                callback(["query": ["success": "no"]])
                return
            }
            let JSON = snapshot.value as! Dictionary<String, Any>
            let retVal = [
                "query": [
                    "success": "yes",
                    "teams": JSON
                ]
            ]
            callback(retVal as NSDictionary)
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
