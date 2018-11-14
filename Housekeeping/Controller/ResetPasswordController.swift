//
//  ResetPasswordController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-08.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordController: UIViewController {
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var ButtonStyle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ButtonStyle.layer.cornerRadius = 15
        ButtonStyle.showsTouchWhenHighlighted = true
        
        self.navigationController?.navigationBar.isHidden = false
    }
    

    
    @IBAction func ChangePasswordButton(_ sender: Any) {
        resetPassword(email: EmailTextField.text!)
    }
    

    func createAlertLogIn(title: String, message:String ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil{
                self.createAlertLogIn(title: "Återställ lösenord!", message: "Ett meddelande med information på hur du ändrar ditt lösenord har skickats till din e-postadress")
            } else{
                print(error!.localizedDescription)
            }
        })
    }

}
