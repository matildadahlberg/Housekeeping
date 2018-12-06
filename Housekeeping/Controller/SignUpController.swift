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
    
    //"https://housekeeping-5d390.firebaseio.com/"
    
    var ref: DatabaseReference!
    var currentUserId = Auth.auth().currentUser?.uid
    
    private let userRef = Database.database().reference()
    
    static let system = User()
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CreateAccButton: UIButton!
    
    var user : [User] = []
    var users: User?
    
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
            
            
        { (user, error) in
            if error != nil {
                print(error)
                SVProgressHUD.dismiss()
                
                self.createAlertSignUp(title: "Något gick fel!", message: "Antingen används redan e-postadressen eller så är lösenordet för kort")
            }
            
            else if let user = user{
                SVProgressHUD.dismiss()

                
                var userInfo = [String: AnyObject]()
                
                userInfo = ["email" : Auth.auth().currentUser?.email as AnyObject, "id" : user.uid as AnyObject,]
                self.userRef.child(user.uid).setValue(userInfo)
                
                let changeName = Auth.auth().currentUser?.createProfileChangeRequest()
                changeName?.displayName = self.NameTextField.text
                changeName?.commitChanges { (error) in
                    print(error)
                    
                }
                
                
                print("Inloggning lyckades")
                
                self.currentUserId = Auth.auth().currentUser?.uid
                
                print("signup: " + self.currentUserId!)
                
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
        
    }
    
}


