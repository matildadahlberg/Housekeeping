//
//  User.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-13.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//
//
import Foundation
import Firebase

class User {

    //var name: String!
    var email: String!
    //var uid = Auth.auth().currentUser?.uid
    //var friends: String!

    init(email: String){
        //self.name = name
        //self.friends = ""
        self.email = email
        //self.uid = ""

    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        //name = (snapshotValue["User"] as! String)
        //friends = (snapshotValue["friends"] as! String)
        email = (snapshotValue["Email"] as! String)
        print("mail:\(email)")
        //uid = (snapshotValue["userId"] as! String)
        //id = snapshot.key
    }

    func toAnyObject() -> Any {
        return ["Email": email]
    }
}
