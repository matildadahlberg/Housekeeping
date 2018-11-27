//
//  AddEventController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-08.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class AddEventController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []

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
        

        
        
        repeatTextfield.inputView = pickerRepeat
        
        pickerRepeat.delegate = self
        pickerRepeat.dataSource = self

        
        titleLabel.text = "Titel:"
 
    }


    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "sv")
        dateFormatter.dateFormat = "E, d MMM HH:mm"
 
        datePicker.minimumDate = Date()
        //datePicker.locale = Locale.current
        
        inputDateTextfield.text = dateFormatter.string(from: datePicker.date)
        //print(dateFormatter.string(from: datePicker.date))
    
    }

    @IBAction func pressedAdd(_ sender: Any) {
        //post the data to firebase
 
        let event = Event(dateTitle: inputDateTextfield.text!, eventTitle: titleTextfield.text!, repeatTime: 1)
        
        let eventDB = Database.database().reference().child(currentUserId!).child("Events")
        let childRef = eventDB.childByAutoId()
        childRef.setValue(event.toAnyObject())
        
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
        self.view.endEditing(false)
    }


    func checkName(){
        let text = titleTextfield.text ?? ""
        addbuttonStyle.isEnabled = !text.isEmpty
        
    }
    
//    func checkDate(){
//        if Date.earlierDate(datePicker.date) == datePicker.date{
//            addbuttonStyle.isEnabled = false
//        }
//
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        checkName()
//    }
    
    
    
    
    
    


}
    
    


  
   


