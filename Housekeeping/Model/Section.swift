//
//  Section.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-10.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import Foundation
import Firebase

//Section ska innehålla ett datum(som rubrik) och titlar som ligger i listan
//och under datum


struct Section {
    var date: String!
    var dateFormatter = DateFormatter()
    var event: [String]!
    var expanded: Bool!


    init(expanded: Bool){
        dateFormatter.dateFormat = "E, d MMM yyyy"
        self.date = dateFormatter.string(from: Date())
        self.event = []
        self.expanded = expanded
}
    
    
//    init( snapshot : DataSnapshot ) {
//        let snapshotValue = snapshot.value as! [ String : AnyObject]
//        date = snapshotValue["DateTitle"] as? String
//        if let event = snapshotValue["EventTitle"] as? [String] {
//            self.event = event
//        } else {
//            self.event = [String]()
//        }
//        //date = snapshotValue["DateTitle"] as? String
//        user = snapshotValue["User"] as? String
//        id = snapshot.key
//    }
//
//    func toAnyObject() -> Any {
//        return [ "DateTitle" : date, "EventTitle" : event]
//    }
    
}


