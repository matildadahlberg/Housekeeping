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
    var refUser: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []
    
    var event : Event?

    
    @IBOutlet weak var tableViewHome: UITableView!
    
    //    var sections = [
    //        Section(date: "E, d MMM yyyy HH:mm", event: [String](), expanded: false)
    //    ]
    
    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        
        tableViewHome.register(UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        self.navigationController?.navigationBar.isHidden = false
        
        currentUserId = Auth.auth().currentUser?.uid
        print( currentUserId)
        ref = Database.database().reference().child(currentUserId!)
   
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
        print(Auth.auth().currentUser?.uid)
        cell.userNameCell.text = Auth.auth().currentUser?.displayName
        cell.dateLabel.text = events[indexPath.row].dateTitle
        
        return cell
        
    }
    
    
    //radera genom att swipa
    func tableView(_ tableView: UITableView, commit editingStyle: CustomTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let event = events[indexPath.row]
            self.events.remove(at: indexPath.row)
            self.tableViewHome.deleteRows(at: [indexPath], with: .automatic)
            removeFromDB(event: event)
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
        
        let eventDB = Database.database().reference().child(currentUserId!).child("Events").child(event.id)
        eventDB.removeValue()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
}







