//
//  addFriendController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-20.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class addFriendController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var currentUserId = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var addFriendTable: UITableView!
    
    
    var users : [User] = []
    var user : User?
    
    
    //    var array = [User]()
    var currentArray = [User]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        
        ref = Database.database().reference()
        
        ref.observe(.value, with: {(snapshot) in
            
            var newUsers: [User] = []
            
            for user in snapshot.children{
                
                let listUser = User(snapshot: user as! DataSnapshot)
                newUsers.append(listUser)
            }
            
            self.users = newUsers
            
        })
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("PRESSED")
    }
    
    
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    private func setUpFriends(){
        //        array.append(User(email: currentUserId!))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addFriendTable.dequeueReusableCell(withIdentifier: "Cell") as? searchTableViewCell else{
            return UITableViewCell()
        }
        cell.emailLabel.text = currentArray[indexPath.row].email
        cell.user = currentArray[indexPath.row]
        
        
        ref.child(currentUserId!).child("sendfriendRequests").child((cell.user?.id)!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                if snapshot.exists() == true {
                    print("exists")
                    cell.buttonStyle.isHidden = true
                }
                else {
                    print("does not exist")
                    cell.buttonStyle.setTitle("Lägg till vän", for: .normal)
                }
            }) { (error) in
                print(error.localizedDescription)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentArray = []
            addFriendTable.reloadData()
            return
        }
        currentArray = users.filter({ user -> Bool in
            user.email.lowercased().contains(searchText.lowercased())
        })
        addFriendTable.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
 
    
    
}
