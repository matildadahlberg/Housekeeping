//
//  ShowFriendsViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-28.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class ShowFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friendsData = ["Namn", "Namn", "Namn","Vänförfrågningar:"]
    //var requestData: [String] = ["Vänförfrågningar:"]

    var sections: [String] = ["Vänner"]
    
    //var sectionData: [Int: [String]] = [:]
    
    var segueId = "goToFriendreq"

    @IBOutlet weak var friendstableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //sectionData = [0 : friendsData, 1 : requestData]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text = friendsData[indexPath.row]
        //cell?.textLabel?.text = requestData[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.friendsData.remove(at: indexPath.row)
            self.friendstableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == friendsData.count - 1 {
        performSegue(withIdentifier: segueId, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == friendsData.count - 1 {
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        }
    }
    


}
