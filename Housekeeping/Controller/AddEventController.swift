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
        
        ref = Database.database().reference()

        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(AddEventController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        repeatTextfield.inputView = pickerRepeat
        
        pickerRepeat.delegate = self
        pickerRepeat.dataSource = self

        
        titleLabel.text = "Titel:"
        
        //enabledButtons()
        
       
        
    }

    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        
        //datePicker.isHidden = false
        
        inputDateTextfield.text = dateFormatter.string(from: datePicker.date)
    
    }

    @IBAction func pressedAdd(_ sender: Any) {
        //post the data to firebase
        
        let event = Event(dateTitle: inputDateTextfield.text!, eventTitle: titleTextfield.text!, repeatTime: 1)
        
        let eventDB = Database.database().reference().child(currentUserId!).child("Events")
        let childRef = eventDB.childByAutoId()
        childRef.setValue(event.toAnyObject())
        
        performSegue(withIdentifier: segueHome, sender: self)
        
    }
    func enabledButtons() {
        if ((titleTextfield.inputView) != nil){
            addbuttonStyle.isEnabled = true
        }else{
            addbuttonStyle.isEnabled = false
        }
        
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

  
    
    


}
    
    


  
   


