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
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var ButtonStyle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        ButtonStyle.layer.cornerRadius = 10
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
