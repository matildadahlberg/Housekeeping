//
//  friendRequestViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-29.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class friendRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    private let userRef = Database.database().reference()
    
    @IBOutlet weak var reqTableView: UITableView!
    
    
    var sections: [String] = ["Vänförfrågningar"]
    
    var users : [User] = []
    
    var user : User?
    
    static var currentArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isHidden = false
        
        reqTableView.register(UINib(nibName: "cellFriendReq", bundle: nil), forCellReuseIdentifier: "myCellForFriend")
        
        
        ref = Database.database().reference()
        
        ref.child(currentUserId!).child("friendRequests").observe(.value , with: { (snapshot) in
            
            self.users = []
            for user in snapshot.children{
                let newUser = (user as! DataSnapshot).key
                self.getThisUser(userId: newUser, completion: { (user) in
                    if let user = user{
                        self.users.append(user)//ha email här sen
                        
                        self.reqTableView.reloadData()
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reqTableView.dequeueReusableCell(withIdentifier: "myCellForFriend") as? cellFriendTableViewCell else{
            
            
            return UITableViewCell()
            
        }
        
        cell.nameLabel.text = users[indexPath.row].email
        
        cell.acceptBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        
        cell.acceptBtn.isEnabled = true
        cell.removeBtn.isEnabled = true
        cell.acceptBtn.addTarget(self, action: #selector(self.acceptRequest), for: .touchUpInside)
        cell.removeBtn.addTarget(self, action: #selector(self.removeRequest), for: .touchUpInside)
        
        
        
        
        
        return cell
        //reqTableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    @objc func acceptRequest(_ sender : UIButton){
        
        sender.isEnabled = false
        
        let user = users[sender.tag]
        
        
        if let currentUser = Auth.auth().currentUser{
            ref = Database.database().reference()
            
            let reference = Database.database().reference()
            
            //tar bort requesten
            reference.child(currentUser.uid).child("friendRequests").child(user.id).removeValue()
            
            
            // lägger till i mina vänner
            reference.child(currentUser.uid).child("friends").child(user.id).setValue(true)
            
            //lägger till i den andra vännens vänner"
            reference.child(user.id).child("friends").child(currentUser.uid).setValue(true)
            
           // performSegue(withIdentifier: "goBackFriends", sender: self)
            
           
          
            
        }
    }
    
    @objc func removeRequest(_ sender : UIButton){
        
        sender.isEnabled = false
        
        let deleteUser = users[sender.tag]
        
        if let currentUser = Auth.auth().currentUser{
            
            
            let reference = Database.database().reference()
            reference.child(currentUser.uid).child("friendRequests").child(deleteUser.id).removeValue()
            reference.child(deleteUser.id).child("sendfriendRequests").child(currentUserId!).removeValue()
            
            //self.reqTableView.reloadData()
            
            
            
        }
    }
    
}






