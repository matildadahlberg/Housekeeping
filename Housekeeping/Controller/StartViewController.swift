//
//  StartViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-12-03.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UITabBarController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        

        
        
    }
    
}






