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
    
    
    let addEventText = AddEventController()
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid

    var events : [Event] = []
    var event : Event?
    
    var user : User?
    var users : [User] = []
    
    var date = Date()
    let formatter = DateFormatter()
    
    
    var selected = false
    
    
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
        
        currentUserId = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference().child(currentUserId!)
        
        ref.child("Events").observe(.value, with: {(snapshot) in
            
            //var newEvents: [Event] = []
            
            for event in snapshot.children{
                
                let listEvent = Event(snapshot: event as! DataSnapshot)
                self.events.append(listEvent)
            }
            
            self.tableViewHome.reloadData()
           // print(self.events)
            
        })
        getfriendsEvents()
        friendBadge()
        
        
    }
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if events[indexPath.row].repeatTime == "" || events[indexPath.row].repeatTime == "Aldrig" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
            cell.eventtitleCell.text = events[indexPath.row].eventTitle
            cell.userNameCell.text = events[indexPath.row].userName
            cell.dateLabel.text = events[indexPath.row].dateTitle
            
            
            return cell
        }
        
        
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! RepeatTableViewCell
            cell2.usernameLabel.text = events[indexPath.row].userName
            cell2.eventLabel.text = events[indexPath.row].eventTitle
            cell2.dateCellLabel.text = events[indexPath.row].dateTitle
            cell2.repeatLabel.text = events[indexPath.row].repeatTime

        return cell2
        
        
        
        
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
        

//        if (currentUserId != nil){
//        if editingStyle == .delete {
//            //for i in 1...6{
//                center.removePendingNotificationRequests(withIdentifiers: [events[indexPath.row].eventID])
//
//                center.removeDeliveredNotifications(withIdentifiers:  [events[indexPath.row].eventID])
//
//            center.removePendingNotificationRequests(withIdentifiers: [events[indexPath.row].eventRepeatID])
//
//            center.removeDeliveredNotifications(withIdentifiers:  [events[indexPath.row].eventRepeatID])
//
//
//
//            let eventDB = events[indexPath.row]
//            self.events.remove(at: indexPath.row)
//            self.tableViewHome.deleteRows(at: [indexPath], with: .automatic)
//            removeFromDB(event: eventDB)
//
//
//            print(indexPath.row)
//        }
//
//        }
      
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
//            self.tableViewHome.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            let eventDB = self.events[indexPath.row]
            self.events.remove(at: indexPath.row)
            self.tableViewHome.deleteRows(at: [indexPath], with: .automatic)
            self.removeFromDB(event: eventDB)
            print(self.tableViewHome)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            //print("I want to share: \(self.tableViewHome[indexPath.row])")
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
        
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
                        self.tableViewHome.reloadData()
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










