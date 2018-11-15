//////
//////  User.swift
//////  Housekeeping
//////
//////  Created by Matilda Dahlberg on 2018-11-13.
//////  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//////
////
import Foundation
import Firebase

class User {

    var name: String!
    var email : String!
//    var friends: [String]!

    init(name: String, email: String){
        self.name = name
        //self.friends = []
        self.email = email

    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = (snapshotValue["name"] as! String)
        //friends = snapshotValue["friends"] as! [String]
        email = (snapshotValue["email"] as! String)
    }


    func toAnyObject() -> Any {
        return ["name": name, "email": email]
    }
}
