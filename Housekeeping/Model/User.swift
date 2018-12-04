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
//        if let email = snapshotValue["email"] as? String{
//            self.email = email
//        }
        self.email = snapshotValue["email"] as! String
//        if let id = snapshotValue["id"] as? String{
//            self.id = id
//        }
        self.id = snapshotValue["id"] as! String
        
        //print("mail:\(email)")
   
    }
//
//    func toAnyObject() -> Any {
//        return ["email": email, "id": id]
//    }
}
