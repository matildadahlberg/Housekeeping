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
    
    
    var user : User?
    var Users : [User] = []

    
    @IBOutlet weak var emailLabel: UILabel!
    
    var databaseReference : DatabaseReference!
    var currentUserId = Auth.auth().currentUser?.uid
    
    @IBAction func addFriendBtn(_ sender: Any) {
        
        sendFriendRequest()
        sentFriendRequest()
       
       buttonStyle.setTitle("Vän tillagd", for: .normal)
        
    }
    
    
    
    @IBOutlet weak var buttonStyle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonStyle.layer.cornerRadius = 10
        buttonStyle.setTitle("Lägg till vän", for: .normal)
       
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func sendFriendRequest(){

        if let currentUser = Auth.auth().currentUser{

            databaseReference = Database.database().reference()
            

            let referens = databaseReference.child((user?.id)!)
//            var infoUser = [String: AnyObject]()
//
//            infoUser = ["emailSender" : Auth.auth().currentUser?.email as AnyObject, "id" : currentUser.uid as AnyObject]
//
//            referens.child("friendRequests").setValue(infoUser)
            
            referens.child("friendRequests").child(currentUser.uid).setValue(true)
            
        }


    }
    
    func sentFriendRequest(){
        
        if let currentUser = Auth.auth().currentUser{
            
            databaseReference = Database.database().reference()
            
            let referens = databaseReference.child(currentUser.uid)
            
//            var infoUser = [String: AnyObject]()
//
//            infoUser = ["emailRetriever" : user?.email as AnyObject, "id" : currentUser.uid as AnyObject]
//
//            referens.child("sendfriendRequests").setValue(infoUser)
            
            referens.child("sendfriendRequests").child((user?.id)!).setValue(true)
            
        }
        
        
    }



}
