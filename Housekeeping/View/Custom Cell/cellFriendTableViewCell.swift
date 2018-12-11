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
    
    var ref: DatabaseReference!
    
    var currentUserId = Auth.auth().currentUser?.uid
    
    var users : [String] = []
    
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
        
        //friendsRequestId()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
    
        acceptBtn.isSelected = true
        
    }
    
    
    @IBAction func removePressed(_ sender: Any) {

        acceptBtn.isSelected = true
    }
    
    
    func friendsRequestId(){
        ref = Database.database().reference()
        
        ref.child(currentUserId!).child("friendRequests").observe(.value , with: { (snapshot) in
            
            self.users = []
            for users in snapshot.children{
                let newUser = (users as! DataSnapshot).key
                self.getThisUser(userId: newUser, completion: { (users) in
                    if let users = users{
                        self.users.append(users.id)
                        print("HÄRAAA: \(snapshot)")
                        
                    }
                })
            }
        })
    }
    
    func getThisUser(userId: String, completion: @escaping (_ user: User?)->()){
        
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                let user = User(snapshot: snapshot)
                completion(user)
            }
            else{
                completion(nil)
            }
            
        }
        
        
    }
    
}
