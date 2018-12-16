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
        
        UNUserNotificationCenter.current().delegate = (self as! UNUserNotificationCenterDelegate)
        
        self.navigationController?.navigationBar.isHidden = false
        
        titleTextfield.layer.borderWidth = 0.5
        titleTextfield.layer.cornerRadius = 10
        
        inputDateTextfield.layer.borderWidth = 0.5
        inputDateTextfield.layer.cornerRadius = 10
        
        repeatTextfield.layer.borderWidth = 0.5
        repeatTextfield.layer.cornerRadius = 10
        
        
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
        
        let event = Event(dateTitle: inputDateTextfield.text!, eventTitle: titleTextfield.text!, userName: (Auth.auth().currentUser?.displayName)!)
        
        let eventDB = Database.database().reference().child(currentUserId!).child("Events")
        let childRef = eventDB.childByAutoId()
        childRef.setValue(event.toAnyObject())
        
        scheduleNotification()
        //setNotification()
        print(UIApplication.shared.scheduledLocalNotifications?.count)
        
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
        
        repeatTextfield.text = repeatDay[row]
        
        if repeatDay[0] == repeatTextfield.text {
            print("aldrig")
            scheduleNotification()
        }
        if repeatDay[1] == repeatTextfield.text {
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86_400, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let request = UNNotificationRequest(identifier: "notificationDay", content: content, trigger: trigger)
            
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
        }
        if repeatDay[2] == repeatTextfield.text {
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604_800, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let request = UNNotificationRequest(identifier: "notificationWeek", content: content, trigger: trigger)
            
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            
        }
        if repeatDay[3] == repeatTextfield.text {
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1_209_600, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let request = UNNotificationRequest(identifier: "notification2Week", content: content, trigger: trigger)
            
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            
        }
        if repeatDay[4] == repeatTextfield.text {
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2_629_800, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let request = UNNotificationRequest(identifier: "notificationMonth", content: content, trigger: trigger)
            
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            
        }
        if repeatDay[5] == repeatTextfield.text {
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 31_557_600, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let request = UNNotificationRequest(identifier: "notificationYear", content: content, trigger: trigger)
            
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            
        }
        
        
        self.view.endEditing(false)
    }
    
    
    func checkName(){
        let text = titleTextfield.text ?? ""
        addbuttonStyle.isEnabled = !text.isEmpty
        
    }
    
    func scheduleNotification() {
        
        let calander = Calendar(identifier: .gregorian)
        var components = calander.dateComponents(in: .current, from: datePicker.date)
        let newComponents = DateComponents(calendar: calander, timeZone: .current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, weekday: components.weekday)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Du har hushållssysslor att göra!"
        content.body = "Glöm inte att \(titleTextfield.text!)!"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        
        
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
            print("Uh oh! we had an error:\(error)")
            
            }
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextfield.resignFirstResponder()
        return(true)
    }
    
    
    
}

extension AddEventController : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
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

//    func setNotification() {
//
//        let center = UNUserNotificationCenter.current()
//
//        let title = titleTextfield.text
//
//        let content = UNMutableNotificationContent()
//        content.title = "Du har hushållssysslor att göra!"
//        content.body = "Glöm inte att \(title!)!"
//        content.badge = 0
//        content.sound = UNNotificationSound.default
//
//        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .weekday, .month, .year], from: datePicker.date)
//
//       let components = DateComponents()
//        time.hour = dateComponents.hour!
//        time.minute = dateComponents.minute!
//        time.weekday = dateComponents.weekday!
//        time.month = dateComponents.month!
//        time.year = dateComponents.year!
//        print(time.weekday)
//
//
//        let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: true)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString
//            , content: content, trigger: trigger)
//
//            center.add(request, withCompletionHandler: nil)
//    }
//
//}
//
//
//struct time {
//    static var hour = 0
//    static var minute = 0
//    static var weekday = 0
//    static var month = 0
//    static var year = 0
//}

