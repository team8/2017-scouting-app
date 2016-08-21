//
//  User.swift
//  scouter
//
//  Created by Robert Selwyn on 8/20/16.
//  Copyright © 2016 Paly Robotics. All rights reserved.
//

import Foundation

class User {
    
    var user_name : String
    var db_id : Int
    
    init(name: String, db_id: Int) {
        self.user_name = name
        self.db_id = db_id
    }

}