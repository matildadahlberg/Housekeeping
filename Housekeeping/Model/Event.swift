//
//  Event.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-13.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import Foundation
import Firebase

class Event {
    
    var dateTitle: String!
    var dateFormatter = DateFormatter()
    var eventTitle: String!
    var repeatTime: Int
    var id: String
    
    init(dateTitle: String, eventTitle: String, repeatTime: Int){
        dateFormatter.dateFormat = "E, d MMM yyyy"
        self.dateTitle = dateFormatter.string(from: Date())
        self.eventTitle = eventTitle;
        self.repeatTime = repeatTime
        self.id = ""
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateTitle = (snapshotValue["DateTitle"] as! String)
        eventTitle = (snapshotValue["EventTitle"] as! String)
        repeatTime = (snapshotValue["Repeat"] as! Int)
        id = snapshot.key
    }
    
    
    func toAnyObject() -> Any {
        return ["DateTitle": dateTitle, "EventTitle": eventTitle, "Repeat": repeatTime]
    }
}



