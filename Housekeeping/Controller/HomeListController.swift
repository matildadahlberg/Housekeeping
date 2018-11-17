//
//  ViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-05.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase


class HomeListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    //ExpandableHeaderViewDelegate

    var ref: DatabaseReference! 
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []
    
    var event : Event?

    var users : [User] = []

    var expanded : Bool = true
 
    @IBOutlet weak var tableViewHome: UITableView!
    
    //    var sections = [
//        Section(date: "E, d MMM yyyy HH:mm", event: [String](), expanded: false)
//    ]

    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHome.register(UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "myCell")

        self.navigationController?.navigationBar.isHidden = false
        
        
        
        ref = Database.database().reference().child(currentUserId!)

//        if (events == nil) {
//            events = []
//
//        }
        
        ref.child("Events").observe(.value, with: {(snapshot) in
            
            var newEvents: [Event] = []
            
            for event in snapshot.children{
                
                let listEvent = Event(snapshot: event as! DataSnapshot)
                newEvents.append(listEvent)
            }
            
            self.events = newEvents
            self.tableViewHome.reloadData()
            print(self.events)
            
        })
        
      
        fetchUser()
        
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return events.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (expanded == true){
            return 64
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = ExpandableHeaderView()
//        //if let ev = event{
//            header.customInit(title: events[section].dateTitle, section: section, delegate: self)
//
//        return header
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
        
        cell.eventtitleCell.text = events[indexPath.row].eventTitle
        //cell.userNameCell.text = users[indexPath.row].name

        return cell
        
    }
    
    
//    func toggleSection(header: ExpandableHeaderView, section: Int) {
//        //events[section].expanded = !events[section].expanded
//        if(expanded == true){
//            tableView.beginUpdates()
//            for i in 0 ..< events[section].eventTitle.count{
//                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
//            }
//            tableView.endUpdates()
//        }
//    }
    

    //radera genom att swipa
    func tableView(_ tableView: UITableView, commit editingStyle: CustomTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let event = events[indexPath.row]
            events.remove(at: indexPath.row)
            removeFromDB(event: event)
            tableViewHome.reloadData()
        }    }
    
    // lägger till ett checkmark vid högra sidan i tableviewn om man klickar på den och tar bort om man klickar igen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
            {

                tableViewHome.deselectRow(at: indexPath, animated: true)
                
                if tableView == tableViewHome {
                    if tableView.cellForRow(at: indexPath)?.accessoryType == CustomTableViewCell.AccessoryType.checkmark{
                        tableView.cellForRow(at: indexPath)?.accessoryType = CustomTableViewCell.AccessoryType.none
                    }else{
                        tableView.cellForRow(at: indexPath)?.accessoryType = CustomTableViewCell.AccessoryType.checkmark
                    }
                }
            }


    func fetchUser() {
        let userDB = Database.database().reference().child(currentUserId!)
        
        userDB.child("User").observe(.value, with: {(snapshot) in
            
            var newUsers: [User] = []
            
            for user in snapshot.children{
                
                let listUser = User(snapshot: user as! DataSnapshot)
                newUsers.append(listUser)
            }
            
            self.users = newUsers
            self.tableViewHome.reloadData()
            print(self.users)
            
        })
    }
    
    func removeFromDB(event : Event){
        
        let evRef = ref.child(currentUserId!).child("Events").child(event.id)
        evRef.removeValue()
    }
  
    

    
}


