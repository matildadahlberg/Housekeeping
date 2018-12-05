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

    var email: String
    var id : String
  

    init(email: String, id: String){
      
        self.email = email
        self.id = id

    }
    
    init() {
        
        self.email = "empty"
        self.id = "empty"
        
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]

        self.email = snapshotValue["email"] as! String

        self.id = snapshotValue["id"] as! String

    }
//
//    func toAnyObject() -> Any {
//        return ["email": email, "id": id]
//    }
}
