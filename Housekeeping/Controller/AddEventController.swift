//
//  AddEventController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-08.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class AddEventController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []
    var event : Event?

    let segueHome = "goToHome"

    @IBOutlet weak var repeatTextfield: UITextField!
    
    @IBOutlet weak var addbuttonStyle: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var inputDateTextfield: UITextField!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickerRepeat = UIPickerView()
    
    var repeatDay = ["Aldrig","Varje dag", "Varje vecka", "Varannan vecka","Varje månad", "Varje år"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        titleTextfield.layer.borderColor = UIColor(red: 42.0/255.0, green: 121.0/255.0, blue: 103.0/255.0, alpha: 1.0).cgColor
        titleTextfield.layer.borderWidth = 1.0
        
        inputDateTextfield.layer.borderColor = UIColor(red: 42.0/255.0, green: 121.0/255.0, blue: 103.0/255.0, alpha: 1.0).cgColor
        
        inputDateTextfield.layer.borderWidth = 1.0
        
        repeatTextfield.layer.borderColor = UIColor(red: 42.0/255.0, green: 121.0/255.0, blue: 103.0/255.0, alpha: 1.0).cgColor
        
        repeatTextfield.layer.borderWidth = 1.0
        
        
        ref = Database.database().reference()

        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(AddEventController.dateChanged(datePicker:)), for: .valueChanged)
        
        self.titleTextfield.delegate = self
        
        
        repeatTextfield.inputView = pickerRepeat
        
        pickerRepeat.delegate = self
        pickerRepeat.dataSource = self

        
        titleLabel.text = "Titel:"
 
    }


    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sv")
        dateFormatter.dateFormat = "E, d MMM HH:mm"
        //datePicker.minimumDate = Date()
        //datePicker.locale = Locale.current
        
        inputDateTextfield.text = dateFormatter.string(from: datePicker.date)
        print(dateFormatter.string(from: datePicker.date))
    
    }

    @IBAction func pressedAdd(_ sender: Any) {
        //post the data to firebase
 
//        let event = Event(dateTitle: inputDateTextfield.text!, eventTitle: titleTextfield.text!, repeatTime: 1)
        
        let event = Event(dateTitle: inputDateTextfield.text!, eventTitle: titleTextfield.text!, userName: (Auth.auth().currentUser?.displayName)!)
        
        let eventDB = Database.database().reference().child(currentUserId!).child("Events")
        let childRef = eventDB.childByAutoId()
        childRef.setValue(event.toAnyObject())
        
        setNotification()
       
        performSegue(withIdentifier: segueHome, sender: self)
        
    }
  
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repeatDay.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repeatDay[row]
    }
    
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let notification:UILocalNotification = UILocalNotification()
        
        repeatTextfield.text = repeatDay[row]
        
        if repeatDay[0] == repeatTextfield.text {
            print("aldrig")
        }
        if repeatDay[1] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.day
        }
        if repeatDay[2] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.weekday
        }
        if repeatDay[3] == repeatTextfield.text {
            
        }
        if repeatDay[4] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.month
        }
        if repeatDay[5] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.year
            
        }
        
        self.view.endEditing(false)
    }


    func checkName(){
        let text = titleTextfield.text ?? ""
        addbuttonStyle.isEnabled = !text.isEmpty
        
    }
    
    func setNotification() {
        let center = UNUserNotificationCenter.current()

        getEvents()
        
        let content = UNMutableNotificationContent()
        content.title = "Du har hushållssysslor att göra!"
        content.body = "Glöm inte att utföra dina hushållssysslor idag"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute, .year], from: datePicker.date)
     
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDate, repeats: true)
        
        let notification = UILocalNotification()
        
        if repeatDay[0] == repeatTextfield.text {
            print("aldrig")
        }
        if repeatDay[1] == repeatTextfield.text {
            //trigger.nextTriggerDate()?.addTimeInterval(pickerRepeat)
            notification.repeatInterval = NSCalendar.Unit.day
        }
        if repeatDay[2] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.weekday
        }
        if repeatDay[3] == repeatTextfield.text {
            
        }
        if repeatDay[4] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.month
        }
        if repeatDay[5] == repeatTextfield.text {
            notification.repeatInterval = NSCalendar.Unit.year
            
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString
            , content: content, trigger: trigger)
            center.add(request)
        
        
        
        
    }
        
//
//        dateComponents.hour = datePicker.calendar
//        dateComponents.minute = 42
//        dateComponents.weekday = 2
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.add(request)
    //}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextfield.resignFirstResponder()
        return(true)
    }
    
    func getEvents(){
    currentUserId = Auth.auth().currentUser?.uid
    
    ref = Database.database().reference().child(currentUserId!)
    
        ref!.child("Events").observe(.value, with: {(snapshot) in
    
    var newEvents: [Event] = []
    
    for event in snapshot.children{
    
    let listEvent = Event(snapshot: event as! DataSnapshot)
    newEvents.append(listEvent)
    }
    print(snapshot)
    self.events = newEvents
    
    
    })
    }
    
//    func checkDate(){
//        if Date.earlierDate(datePicker.date) == datePicker.date{
//            addbuttonStyle.isEnabled = false
//        }
//
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        checkName()
//    }
    
    
    
    
    
    
    
    


}
    
    


  
   


