//
//  LogInController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-08.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextfield: UITextField!
    
    @IBOutlet weak var LogInButton: UIButton!
    
    @IBOutlet weak var CreateAccountButton: UIButton!
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var imageBG: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimation()
        
        PasswordTextfield.delegate = self
        
     
        LogInButton.layer.cornerRadius = 5
        CreateAccountButton.layer.cornerRadius = 5
        
        LogInButton.showsTouchWhenHighlighted = true
        CreateAccountButton.showsTouchWhenHighlighted = true
  
        self.navigationController?.navigationBar.isHidden = true
        
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToHomeList", sender: self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation()
        
        
        LogInButton.layer.cornerRadius = 5
        CreateAccountButton.layer.cornerRadius = 5
        
        LogInButton.showsTouchWhenHighlighted = true
        CreateAccountButton.showsTouchWhenHighlighted = true
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }

// tar bort tangentbordet när man klickar någonstans utanför det
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}

// tar bort tangentbordet när man klicka på return
func textFieldShouldReturn(_ PasswordTextField: UITextField) -> Bool {
    PasswordTextField.resignFirstResponder()
    return(true)
}

func createAlertLogIn(title: String, message:String ){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
        alert.dismiss(animated: true, completion: nil)
    }))
    
    self.present(alert, animated: true, completion: nil)
}
    

    @IBAction func LogInPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextfield.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                self.createAlertLogIn(title: "Något gick fel", message: "Försök igen!")
                print(error!)
            }
            else {
                SVProgressHUD.dismiss()
                print("Login In Successful")
                self.performSegue(withIdentifier: "goToHomeList", sender: self)
            }
        }
    }
    
    func startAnimation() {
        
            header.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = header.bounds
            header.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 3
            animation.fromValue = -header.frame.size.width
            animation.toValue = header.frame.size.width
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "")
        
    }
  
  
    
    
    


}
