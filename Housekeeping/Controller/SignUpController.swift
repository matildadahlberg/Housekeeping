//
//  SignUpController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-08.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpController: UIViewController {
    
    var ref: DatabaseReference!
    var currentUserId = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var orangeButton: UIButton!
    
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var babyBlueButton: UIButton!
    
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var purpleButton: UIButton!
    
    @IBOutlet weak var blackButton: UIButton!
    
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CreateAccButton: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CreateAccButton.layer.cornerRadius = 15
        CreateAccButton.showsTouchWhenHighlighted = true
        
        self.navigationController?.navigationBar.isHidden = false
        
        buttonDesign()

    }
    
    
    
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!)
        let eventDB = Database.database().reference().child(currentUserId!)
        let nameDictionary = ["User": Auth.auth().currentUser?.email, "name" : NameTextField.text]
        eventDB.childByAutoId().setValue(nameDictionary)
            
        { (user, error) in
            if error != nil {
                print(error)
                SVProgressHUD.dismiss()
                
                self.createAlertSignUp(title: "Något gick fel!", message: "Antingen används redan e-postadressen eller så är lösenordet för kort")
            }
            else {
                SVProgressHUD.dismiss()
                print("Inloggning lyckades")
                
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    func createAlertSignUp(title: String, message:String ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Försök igen", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func buttonDesign(){
        
        CreateAccButton.layer.cornerRadius = 15
        CreateAccButton.showsTouchWhenHighlighted = true
        
        redButton.layer.cornerRadius = 15
        redButton.showsTouchWhenHighlighted = true
        
        yellowButton.layer.cornerRadius = 15
        yellowButton.showsTouchWhenHighlighted = true
        
        orangeButton.layer.cornerRadius = 15
        orangeButton.showsTouchWhenHighlighted = true
        
        greenButton.layer.cornerRadius = 15
        greenButton.showsTouchWhenHighlighted = true
        
        babyBlueButton.layer.cornerRadius = 15
        babyBlueButton.showsTouchWhenHighlighted = true
        
        blueButton.layer.cornerRadius = 15
        blueButton.showsTouchWhenHighlighted = true
        
        purpleButton.layer.cornerRadius = 15
        purpleButton.showsTouchWhenHighlighted = true
        
        blackButton.layer.cornerRadius = 15
        blackButton.showsTouchWhenHighlighted = true

    }
    
}


