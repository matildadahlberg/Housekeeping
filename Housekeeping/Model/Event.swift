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
    let ref: DatabaseReference?
    var dateTitle: String!
    var dateFormatter = DateFormatter()
    var eventTitle: String!
    var userName : String
    var repeatTime : String!
    
    var eventID: String!
    var eventRepeatID: String
    var id : String
    
    var completed : Bool
    

    init(dateTitle: String, eventTitle: String, userName: String, eventID: String, eventRepeatID: String, repeatTime: String, completed: Bool){
//        dateFormatter.locale = Locale(identifier: "sv")
//        dateFormatter.dateFormat = "E, d MMM HH:mm"
        self.dateTitle = dateTitle
//        self.dateTitle = dateFormatter.string(from: Date(dateTitle))
        self.eventTitle = eventTitle
        self.userName = userName
        self.eventID = eventID
        self.eventRepeatID = eventRepeatID
        self.repeatTime = repeatTime
        self.completed = completed
 
        self.id = ""
        
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateTitle = (snapshotValue["DateTitle"] as! String)
        eventTitle = (snapshotValue["EventTitle"] as! String)
        userName = (snapshotValue["username"] as! String)
        repeatTime = (snapshotValue["repeatTime"] as! String)
        eventID = (snapshotValue["eventID"] as! String)
        eventRepeatID = (snapshotValue["eventRepeatID"] as! String)
        completed = (snapshotValue["completed"] as! Bool)
     
        
        id = snapshot.key
        
        self.ref = snapshot.ref
        
    
        
    }
    
    
    func toAnyObject() -> Any {
        return ["DateTitle": dateTitle, "EventTitle": eventTitle, "username": userName, "repeatTime": repeatTime, "eventID" : eventID, "eventRepeatID" : eventRepeatID, "completed" : completed]
    }
}



