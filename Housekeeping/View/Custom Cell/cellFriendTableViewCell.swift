//
//  cellFriendTableViewCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-30.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class cellFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptBtn: UIButton!
    
    
    @IBOutlet weak var removeBtn: UIButton!
    
  
    @IBOutlet weak var nameLabel: UILabel!
    
    var user : User?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
        acceptBtn.layer.cornerRadius = 10
        removeBtn.layer.cornerRadius = 10
        removeBtn.layer.borderWidth = 1
        removeBtn.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        
        if let currentUser = Auth.auth().currentUser{
            
            let reference = Database.database().reference()
            
            // add to friendpage.
            reference.child(currentUser.uid).child("friends").child((user?.id)!).setValue(true)
            
            //Add to the other users "friends" page
            reference.child((user?.id)!).child("friends").child(currentUser.uid).setValue(true)

        }
        
        
    }
    
    
    @IBAction func removePressed(_ sender: Any) {
        
        if let currentUser = Auth.auth().currentUser{
            
            //delete request.
            let reference = Database.database().reference()
            reference.child(currentUser.uid).child("friendRequests").child((user?.id)!).removeValue()
        }
    }
    
    
    

}
