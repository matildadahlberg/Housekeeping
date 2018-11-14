//
//  SettingsTableViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-12.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

var settingArray = ["Min Profil","Använd färdig städlista","Vänner","Logga ut"]
var myIndex = 0

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUserId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

    }

    // MARK: - Table view data source


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (settingArray.count)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = settingArray[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "goToProfile", sender: self)
        }
        if indexPath.row == 1{
            performSegue(withIdentifier: "goToCleanList", sender: self)
        }
        if indexPath.row == 2{
            performSegue(withIdentifier: "goToFriends", sender: self)
        }
        if indexPath.row == 3{
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "logOut", sender: self)
                
                //navigationController?.popToRootViewController(animated: true)
                
            }
            catch {
                print("error: there was a problem logging out")
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}