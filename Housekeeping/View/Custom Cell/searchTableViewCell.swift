//
//  searchTableViewCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-20.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class searchTableViewCell: UITableViewCell {
    
    var arrayOfUsers = [User]()
    var users : User?
    var Users : [User] = []

    @IBOutlet weak var emailLabel: UILabel!
    
    var databaseReference : DatabaseReference!
    var currentUserId = Auth.auth().currentUser?.uid
    
    @IBAction func addFriendBtn(_ sender: Any) {
        sendFriendRequest()
    }
    
    
    @IBOutlet weak var buttonStyle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonStyle.layer.cornerRadius = 10
        

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func sendFriendRequest(){


        if let currentUser = Auth.auth().currentUser{

            databaseReference = Database.database().reference()


            let referens = databaseReference.child(currentUserId!)
            referens.child("friendRequests").child(currentUser.uid).setValue(true)

        }



    }

}
