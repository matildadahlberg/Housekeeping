//
//  ViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-05.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


class HomeListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    //ExpandableHeaderViewDelegate
    
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid

    var events : [Event] = []
    var event : Event?
    
    var user : User?
    var users : [User] = []
    
    
    @IBOutlet weak var tableViewHome: UITableView!
    
    
    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        
        tableViewHome.register(UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        self.navigationController?.navigationBar.isHidden = false
        
        currentUserId = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference().child(currentUserId!)
        
        ref.child("Events").observe(.value, with: {(snapshot) in
            
            //var newEvents: [Event] = []
            
            for event in snapshot.children{
                
                let listEvent = Event(snapshot: event as! DataSnapshot)
                self.events.append(listEvent)
            }
            print(snapshot)
           // self.events = newEvents
            self.tableViewHome.reloadData()
            print(self.events)
            
        })
        getfriendsEvents()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
        
        cell.eventtitleCell.text = events[indexPath.row].eventTitle
        cell.userNameCell.text = events[indexPath.row].userName
        
       // cell.userNameCell.text = Auth.auth().currentUser?.displayName
        cell.dateLabel.text = events[indexPath.row].dateTitle
        
        return cell
        
    }
    
    
    //radera genom att swipa
    func tableView(_ tableView: UITableView, commit editingStyle: CustomTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let center = UNUserNotificationCenter.current()
        
        if editingStyle == .delete {
            let event = events[indexPath.row]
            self.events.remove(at: indexPath.row)
            self.tableViewHome.deleteRows(at: [indexPath], with: .automatic)
            removeFromDB(event: event)
            center.removeAllPendingNotificationRequests()
            tableViewHome.reloadData()
            print(indexPath.row)
        }
        
        
    }
    
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func removeFromDB(event : Event){
        
        if (currentUserId != nil){
            
            let eventDB = Database.database().reference().child(currentUserId!).child("Events").child(event.id)
            eventDB.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getfriendsEvents(){
        currentUserId = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        ref.child(currentUserId!).child("friends").observe(.value , with: { (snapshot) in
            
            self.users = []
            for user in snapshot.children{
                let newUser = (user as! DataSnapshot).key
                self.getThisUser(userId: newUser, completion: { (user) in
                    if let user = user{
                        self.users.append(user)
                        
                        self.ref.child(user.id).child("Events").observe(.value, with: {(snapshot) in
                            
                           // var newEvents: [Event] = []
                            
                            for event in snapshot.children{
                                
                                let listEvent = Event(snapshot: event as! DataSnapshot)
                                self.events.append(listEvent)
                            }
                            print(snapshot)
                           // self.events = newEvents
                            self.tableViewHome.reloadData()
                            print(self.events)
                            
                        })
                       
                        print("HÄÄÄÄR: \(snapshot)")
                        
                        self.tableViewHome.reloadData()
                    }
                })
            }
        })
        
//        ref.child("Events").observe(.value, with: {(snapshot) in
//
//            var newEvents: [Event] = []
//
//            for event in snapshot.children{
//
//                let listEvent = Event(snapshot: event as! DataSnapshot)
//                newEvents.append(listEvent)
//            }
//            print(snapshot)
//            self.events = newEvents
//            self.tableViewHome.reloadData()
//            print(self.events)
//
//        })
    }
    
    
    func getThisUser(userId: String, completion: @escaping (_ user: User?)->()){
        
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                let user = User(snapshot: snapshot)
                completion(user)
            }
            else{
                completion(nil)
            }
            
        }
        
        
    }
    
    
}




