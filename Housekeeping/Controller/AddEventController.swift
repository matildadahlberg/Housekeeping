//
//  AddEventController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-08.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class AddEventController: UIViewController {
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var events : [Event] = []
    
    @IBOutlet weak var repeatBtn: UISegmentedControl!
    

    let segueHome = "goToHome"

   
    @IBOutlet weak var addbuttonStyle: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var inputDateTextfield: UITextField!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
 
        ref = Database.database().reference()
       

        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(AddEventController.dateChanged(datePicker:)), for: .valueChanged)
   
        //datePicker.isHidden = true
        
        titleLabel.text = "Titel:"
        
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
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//            return true
//        }
    
        
        //dismiss the popover
    //presentingViewController?.dismiss(animated: true, completion: nil)

    func enabledButtons() {
        if (titleTextfield.text != ""){
            addbuttonStyle.isEnabled = true
        }else{
            addbuttonStyle.isEnabled = false
        }
        
    }


}
    
    


  
   


