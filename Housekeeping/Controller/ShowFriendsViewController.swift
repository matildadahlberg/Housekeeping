//
//  ShowFriendsViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-28.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class ShowFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var friendsData: [String] = ["Namn", "Namn", "Namn"]
    var requestData: [String] = ["Namn förfrågan", "Namn förfrågan"]

    var sections: [String] = ["Vänner", "Vänförfrågningar"]
    
    var sectionData: [Int: [String]] = [:]

    @IBOutlet weak var friendstableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        acceptBtn.layer.cornerRadius = 10
        removeBtn.layer.cornerRadius = 10
        removeBtn.layer.borderWidth = 1
        removeBtn.layer.borderColor = UIColor.black.cgColor
        
        sectionData = [0 : friendsData, 1 : requestData]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        
        cell?.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        
        return cell!
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
    


}
