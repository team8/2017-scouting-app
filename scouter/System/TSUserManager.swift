//
//  UserManager.swift
//  scouter
//
//  Created by Robert Selwyn on 8/20/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation

class UserManager {
    
    static let NAME_KEY = "Name"
    static let DB_ID_KEY = "ID"
    
    static var defaults = NSUserDefaults.standardUserDefaults()
    
    static func loadUser() -> User {
        let name = defaults.stringForKey(NAME_KEY)
        let dbid = defaults.integerForKey(DB_ID_KEY)
        return User(name: name!, db_id: dbid)
    }
    
    static func saveUser(user: User) -> Void {
        defaults.setValue(user.db_id, forKey: DB_ID_KEY)
        defaults.setValue(user.user_name, forKey: NAME_KEY)
    }
    
}