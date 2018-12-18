//
//  Event.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-13.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Event {
    
    var dateTitle: String!
    var dateFormatter = DateFormatter()
    var eventTitle: String!
    var userName : String
    var repeatTime : String!
    
    var id: String!
    
    init(dateTitle: String, eventTitle: String, userName: String, id: String, repeatTime: String){
//        dateFormatter.locale = Locale(identifier: "sv")
//        dateFormatter.dateFormat = "E, d MMM HH:mm"
        self.dateTitle = dateTitle
//        self.dateTitle = dateFormatter.string(from: Date(dateTitle))
        self.eventTitle = eventTitle
        self.userName = userName
        self.id = id
        self.repeatTime = repeatTime
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateTitle = (snapshotValue["DateTitle"] as! String)
        eventTitle = (snapshotValue["EventTitle"] as! String)
        userName = (snapshotValue["username"] as! String)
        repeatTime = (snapshotValue["repeatTime"] as! String)
        id = (snapshotValue["eventID"] as! String)
        
        
        //id = snapshot.key
    }
    
    
    func toAnyObject() -> Any {
        return ["DateTitle": dateTitle, "EventTitle": eventTitle, "username": userName, "repeatTime": repeatTime, "eventID" : id]
    }
}



