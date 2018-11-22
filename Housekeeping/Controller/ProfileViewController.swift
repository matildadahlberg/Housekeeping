//
//  ProfileViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-12.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        let name = Auth.auth().currentUser?.displayName
        self.nameTextField.text = name
        
    }
    

    @IBAction func changeNameButton(_ sender: Any) {
        let changeName = Auth.auth().currentUser?.createProfileChangeRequest()
        changeName?.displayName = self.nameTextField.text
        changeName?.commitChanges { (error) in
            print(error)
            
        }
    }
    

}
