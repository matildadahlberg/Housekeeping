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

enum repeatValue : String {
    case never = "Aldrig", day = "Varje dag", week = "Varje vecka", twoTimesInMounth = "Varannan vecka", mounth = "Varje månad", year = "Varje år"
}

class AddEventController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []
    var event : Event?
    
    
    let segueHome = "goToHome"
    
    var identifier = UUID().uuidString
    var identifierRepeat = UUID().uuidString
    
    @IBOutlet weak var repeatTextfield: UITextField!
    
    @IBOutlet weak var addbuttonStyle: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var inputDateTextfield: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var pickerRepeat = UIPickerView()
    
    //var repeatDay = ["Aldrig","Varje dag", "Varje vecka", "Varannan vecka","Varje månad", "Varje år"]
    
    var repeatDay : [repeatValue] = [repeatValue.never, repeatValue.day, repeatValue.week, repeatValue.twoTimesInMounth, repeatValue.mounth, repeatValue.year]
    var selectedRepeatVal = repeatValue.never
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = (self as! UNUserNotificationCenterDelegate)
        
        self.navigationController?.navigationBar.isHidden = false
        let myColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 244.0/255, alpha: 1.0)
        
        titleTextfield.layer.borderWidth = 0.5
        titleTextfield.layer.cornerRadius = 10
        titleTextfield.layer.borderColor = myColor.cgColor
        
        inputDateTextfield.layer.borderWidth = 0.5
        inputDateTextfield.layer.cornerRadius = 10
        inputDateTextfield.layer.borderColor = myColor.cgColor
        
        repeatTextfield.layer.borderWidth = 0.5
        repeatTextfield.layer.cornerRadius = 10
        repeatTextfield.layer.borderColor = myColor.cgColor
        
        self.navigationItem.rightBarButtonItem!.isEnabled = false
        
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
        
        switch selectedRepeatVal {
        case .never:
            dateFormatter.dateFormat = "E, d MMM HH:mm"
            print(selectedRepeatVal.rawValue)
        case .day:
            dateFormatter.dateFormat = "HH:mm"
            print(selectedRepeatVal.rawValue)
        case .week:
            dateFormatter.dateFormat = "E, HH:mm"
            
            print(selectedRepeatVal.rawValue)
        case .twoTimesInMounth:
            dateFormatter.dateFormat = "E, HH:mm"
            print(selectedRepeatVal.rawValue)
        case .mounth:
            dateFormatter.dateFormat = "d, HH:mm"
            
            print(selectedRepeatVal.rawValue)
        case .year:
            dateFormatter.dateFormat = "d, HH:mm"
            print(selectedRepeatVal.rawValue)
        }
        inputDateTextfield.text = dateFormatter.string(from: datePicker.date)
    
    
        
    }
    
    @IBAction func pressedAdd(_ sender: Any) {
        //post the data to firebase
        
        
        let event = Event(dateTitle: inputDateTextfield.text!, eventTitle: titleTextfield.text!, userName: (Auth.auth().currentUser?.displayName)!, eventID: identifier, eventRepeatID: identifierRepeat, repeatTime: repeatTextfield.text!)
        
    
        
        
       
        let eventDB = Database.database().reference().child(currentUserId!).child("Events")
        let childRef = eventDB.childByAutoId()
        childRef.setValue(event.toAnyObject())
        
        scheduleNotification()
        
        
        
        
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
        return repeatDay[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRepeatVal = repeatDay[row]
        repeatTextfield.text = selectedRepeatVal.rawValue
        
        switch selectedRepeatVal {
        case .never:
            
            print(selectedRepeatVal.rawValue)
        case .day:
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86_400, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            let notiID = identifierRepeat
            let request = UNNotificationRequest(identifier: notiID, content: content, trigger: trigger)
            
            print("varje dag : \(request.identifier)")
            
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            print(selectedRepeatVal.rawValue)
        case .week:
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604_800, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            let notiID = identifierRepeat
            let request = UNNotificationRequest(identifier: notiID, content: content, trigger: trigger)
            
            print("varje vecka : \(request.identifier)")
            
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            print(selectedRepeatVal.rawValue)
        case .twoTimesInMounth:
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1_209_600, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let notiID = identifierRepeat
            let request = UNNotificationRequest(identifier: notiID, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            print(selectedRepeatVal.rawValue)
            
        case .mounth:
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2_629_800, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let notiID = identifierRepeat
            let request = UNNotificationRequest(identifier: notiID, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            print(selectedRepeatVal.rawValue)
            
        case .year:
            let calander = Calendar(identifier: .gregorian)
            var components = calander.dateComponents(in: .current, from: datePicker.date)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 31_557_600, repeats: true)
            let content = UNMutableNotificationContent()
            content.title = "Du har hushållssysslor att göra!"
            content.body = "Glöm inte att \(titleTextfield.text!)!"
            content.sound = UNNotificationSound.default
            
            
            let notiID = identifierRepeat
            let request = UNNotificationRequest(identifier: notiID, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {(error) in if let error = error {
                print("Uh oh! we had an error:\(error)")
                
                }
            }
            print(selectedRepeatVal.rawValue)
            
        }
        dateChanged(datePicker: datePicker)
    
        self.view.endEditing(false)
    }
    
    
    func checkName(){
        let text = titleTextfield.text ?? ""
        addbuttonStyle.isEnabled = !text.isEmpty
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem!.isEnabled = true
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
        
        
        
        //let idName = titleTextfield.text
        let notiID = identifier
        //notiID += String("6")
        let request = UNNotificationRequest(identifier: notiID, content: content, trigger: trigger)
        
        print("original identifier was : \(request.identifier)")
        
        
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






