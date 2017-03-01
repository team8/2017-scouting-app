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
        print("[Firebase Interactor] Retrieving Firebase data for event " + forKey)
        var completed = false
        ref.child(forKey).observeSingleEvent(of: .value, with: { (snapshot) in
            completed = true
            if (snapshot.value is NSNull) {
                print("[Firebase Interactor] No Firebase data for " + forKey)
                callback(["query": ["success": "no"]])
                return
            }
            print("[Firebase Interactor] Successfully retrieved Firebase data for event " + forKey)
            let JSON = snapshot.value as! Dictionary<String, Any>
            let retVal = [
                "query": [
                    "success": "yes",
                    "event": JSON
                ]
            ]
            callback(retVal as NSDictionary)
        }) { (error) in
            completed = true
            print(error.localizedDescription)
            print("[ERROR] Error getting value from Firebase")
            callback(["query": ["success": "no"]])
        }
        
        DispatchQueue.global(qos: .background).async {
            sleep(30)
            if(!completed) {
//                ref.child(forKey).removeAllObservers()
                print("[Firebase Interactor] Error connecting to Firebase database")
                DispatchQueue.main.async {
                    callback(["query": ["success": "no"]])
                }
            }
        }
    }
    
    static func setValue(forKey: String, value: Any) {
        ref.child(forKey).setValue(value)
    }
}
