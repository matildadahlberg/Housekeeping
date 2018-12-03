//
//  friendRequestViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-29.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class friendRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var reqTableView: UITableView!
    var requestData = ["Namn", "Namn", "Namn", "Namn"]
    
    var sections: [String] = ["Vänförfrågningar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reqTableView.register(UINib(nibName: "cellFriendReq", bundle: nil), forCellReuseIdentifier: "myCellForFriend")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reqTableView.dequeueReusableCell(withIdentifier: "myCellForFriend") as? cellFriendTableViewCell else{
            return UITableViewCell()
        }
        cell.nameLabel.text = requestData[indexPath.row]
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
    
    
    
    

  

}
