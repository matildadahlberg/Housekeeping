//
//  ViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-05.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class myCell {
    

}

class HomeListController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {

    var ref: DatabaseReference! 
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []
    
    var event : Event?
    
    var signUpName : SignUpController?
    
    var expanded : Bool = true
 
    @IBOutlet weak var tableView: UITableView!

 
    
    //    var sections = [
//        Section(date: "E, d MMM yyyy HH:mm", event: [String](), expanded: false)
//    ]

    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        
        ref = Database.database().reference().child(currentUserId!)
   
//        if (eventList == nil) {
//            eventList = []
//
//        }
        
        ref.child("Events").observe(.value, with: {(snapshot) in
            
            var newEvents: [Event] = []
            
            for event in snapshot.children{
                
                let listEvent = Event(snapshot: event as! DataSnapshot)
                newEvents.append(listEvent)
            }
            
            self.events = newEvents
            self.tableView.reloadData()
            print(self.events)
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (expanded == true){
            return 44
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        //if let ev = event{
            header.customInit(title: events[section].dateTitle, section: section, delegate: self)

        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        
        cell.textLabel?.text = events[indexPath.row].eventTitle
     
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        //events[section].expanded = !events[section].expanded
        if(expanded == true){
            tableView.beginUpdates()
            for i in 0 ..< events[section].eventTitle.count{
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            tableView.endUpdates()
        }
    }
    

    //radera genom att swipa
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            event?.eventTitle.remove(at: indexPath.row)
//
//            let eventRef = ref.child(currentUserId!).child("Events").child((event?.id)!)
//            eventRef.child("EventTitle").setValue(event?.eventTitle)
//            tableView.reloadData()
//
//        }
//    }
    
    // lägger till ett checkmark vid högra sidan i tableviewn om man klickar på den och tar bort om man klickar igen
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//                tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//            } else {
//                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            }
//
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    

    func nameInCell(){
        
        let evDB = Database.database().reference().child(currentUserId!)
        
        evDB.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            let data = DataSnapshot.value as! Dictionary <String, String>
            
            let username = data["name"]
            
//            self.usernameLabel.text = username as? String
       
        })
    }
    
}


