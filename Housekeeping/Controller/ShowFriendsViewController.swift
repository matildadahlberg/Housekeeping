//
//  ShowFriendsViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-28.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class ShowFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var currentUserId = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var friendsReqBtn: UIButton!
    
    var sections: [String] = ["Vänner"]
    var users : [User] = []
    var user : User?
    
    var segueId = "goToFriendreq"

    @IBOutlet weak var friendstableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendstableView.register(UINib(nibName: "showFriendCell", bundle: nil), forCellReuseIdentifier: "showCell")
        
        friendsReqBtn.layer.cornerRadius = 10

        
        ref = Database.database().reference()
        
        ref.child(currentUserId!).child("friends").observe(.value , with: { (snapshot) in
            
            self.users = []
            for user in snapshot.children{
                let newUser = (user as! DataSnapshot).key
                self.getThisUser(userId: newUser, completion: { (user) in
                    if let user = user{
                        self.users.append(user)//ha email här sen
                        
                        self.friendstableView.reloadData()
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
        guard let cell = friendstableView.dequeueReusableCell(withIdentifier: "showCell") as? showFriendTableCell else{
            return UITableViewCell()
        }
        
        cell.nameLabel.text = users[indexPath.row].email
        cell.removeButton.tag = indexPath.row
        
        
        cell.removeButton.isEnabled = true
        
        cell.removeButton.addTarget(self, action: #selector(self.removeFriend), for: .touchUpInside)
  
        return cell
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    @IBAction func showFriendsReq(_ sender: Any) {
        
        performSegue(withIdentifier: segueId, sender: self)
    }
    
    @objc func removeFriend(_ sender : UIButton){
        
        sender.isEnabled = false
        
        let deleteUser = users[sender.tag]
        
        if let currentUser = Auth.auth().currentUser{
            
            
            let reference = Database.database().reference()
            reference.child(currentUser.uid).child("friends").child(deleteUser.id).removeValue()
            
            reference.child(deleteUser.id).child("friends").child(currentUserId!).removeValue()
            
            reference.child(deleteUser.id).child("sendfriendRequests").child(currentUserId!).removeValue()

            
            //self.friendstableView.reloadData()
            
            
            
        }
    }

}


