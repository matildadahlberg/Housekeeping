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


class HomeListController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    let addEventText = AddEventController()
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    let refs = Database.database().reference(withPath: "Events")
    
    
    var events : [Event] = []
    var event : Event?
    var eventList : [Event]?
    
    var user : User?
    var users : [User] = []
    
    var date = Date()
    let formatter = DateFormatter()
    
    
    
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var tableViewHome: UITableView!
    
    
    
    
    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        
        tableViewHome.register(UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "myCell")
        tableViewHome.register(UINib(nibName: "cellRepeat", bundle: nil), forCellReuseIdentifier: "cell2")
        
        self.navigationController?.navigationBar.isHidden = false
        
     
        
        
        getEvents()
        getfriendsEvents()
        friendBadge()
        
        
        
          //tableViewHome.reloadData()
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // deselect the selected row if any
        let selectedRow: IndexPath? = tableViewHome.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableViewHome.deselectRow(at: selectedRowNotNill, animated: true)
        }
        
//        getEvents()
//        getfriendsEvents()
//        friendBadge()
    }
    
    func getEvents(){
    currentUserId = Auth.auth().currentUser?.uid
    
    ref = Database.database().reference().child(currentUserId!)
        
    //ref.child("Events").observe(.childAdded, with: {(snapshot) in
        
        ref.child("Events").observe(.childAdded, with: {(snapshot) in
            if snapshot.exists(){
                let listEvent = Event(snapshot: snapshot )
                self.events.append(listEvent)
                
                self.tableViewHome.reloadData()
                
            }
        })
    
//    ref.child("Events").observe(.value, with: {(snapshot) in
//
//    //self.events.removeAll()
//
//
//    //var newEvents: [Event] = []
//
//    for event in snapshot.children{
//
//    let listEvent = Event(snapshot: event as! DataSnapshot)
//    self.events.append(listEvent)
//    }
//
//
//    self.tableViewHome.reloadData()
//    //print(self.events)
//
//
//
//
//    })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result: UITableViewCell
        
        let ev = events[indexPath.row]
        if ev.repeatTime == "" || ev.repeatTime == "Aldrig" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
            
            cell.eventtitleCell.text = ev.eventTitle
            cell.userNameCell.text = ev.userName
            cell.dateLabel.text = ev.dateTitle
            
            
            toggleCellCheckbox(cell, isCompleted: ev.completed)
            
            events.sort(by: {$0.dateTitle < $1.dateTitle})
            
            result = cell
        } else{
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! RepeatTableViewCell
            let ev = events[indexPath.row]
            cell2.usernameLabel.text = ev.userName
            cell2.eventLabel.text = ev.eventTitle
            cell2.dateCellLabel.text = ev.dateTitle
            cell2.repeatLabel.text = ev.repeatTime
            
            toggleCellCheckbox(cell2, isCompleted: ev.completed)
            
            //events.sort(by: {$0.dateTitle < $1.dateTitle})
            
            result = cell2
        }
        return result
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1.0){
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
    
    
    //radera genom att swipa
    func tableView(_ tableView: UITableView, commit editingStyle: CustomTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        //if (currentUserId != nil){
            if editingStyle == .delete {
                
                center.removePendingNotificationRequests(withIdentifiers: [events[indexPath.row].eventID])
                
                center.removeDeliveredNotifications(withIdentifiers:  [events[indexPath.row].eventID])
                
                center.removePendingNotificationRequests(withIdentifiers: [events[indexPath.row].eventRepeatID])
                
                center.removeDeliveredNotifications(withIdentifiers:  [events[indexPath.row].eventRepeatID])
                
                
                
                let eventDB = events[indexPath.row]
                self.events.remove(at: indexPath.row)
                self.tableViewHome.deleteRows(at: [indexPath], with: .automatic)
                removeFromDB(event: eventDB)
                
                
                print(indexPath.row)
            }
            
        //}
        
    }
    
    
    
    // lägger till ett checkmark vid högra sidan i tableviewn om man klickar på den och tar bort om man klickar igen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
         //if (currentUserId != nil){
            
          
        
        guard let cell = tableViewHome.cellForRow(at: indexPath) else { return }
        
        let ev = events[indexPath.row]
        
        let toggledCompletion = !ev.completed
        
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        
        ev.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
       //}
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
         //if (currentUserId != nil){
        if !isCompleted {
            cell.accessoryType = .none
            
        } else {
            cell.accessoryType = .checkmark
            
        }
        //}
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func removeFromDB(event : Event){
        
        //if (currentUserId != nil){
            
            let eventDB = Database.database().reference().child(currentUserId!).child("Events").child(event.id)
            eventDB.removeValue()
        //}
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
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
                        
//                        self.ref.child(user.id).child("Events").observe(.value, with: {(snapshot) in
//
//
//
//                            for event in snapshot.children{
//
//                                let listEvent = Event(snapshot: event as! DataSnapshot)
//                                self.events.append(listEvent)
//                            }
//                            print(snapshot)
//                            // self.events = newEvents
//
//                            self.tableViewHome.reloadData()
//                            print(self.events)
//
//                        })
                        self.ref.child(user.id).child("Events").observe(.childAdded, with: {(snapshot) in
                            if snapshot.exists(){
                                let listEvent = Event(snapshot: snapshot )
                                self.events.append(listEvent)
                                
                                self.tableViewHome.reloadData()
                                
                            }
                        })
                        //self.tableViewHome.reloadData()
                    }
                })
            }
        })
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
    
    func friendBadge(){
        ref = Database.database().reference()
        ref.child(currentUserId!).child("friendRequests")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                if snapshot.exists() == true {
                    print("exists")
                    UIApplication.shared.applicationIconBadgeNumber = 1
                    self.createAlert(title: "Vänförfrågan", message: "Du har fått en vänförfrågan!")
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[2]
                        tabItem.badgeValue = "1"
                        
                        
                    }
                    
                }
                else {
                    print("does not exist")
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[2]
                        tabItem.badgeValue = nil
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func createAlert(title: String, message:String ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}










