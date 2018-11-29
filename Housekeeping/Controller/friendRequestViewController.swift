//
//  friendRequestViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-29.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class friendRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    var requestData = ["Vänförfrågar Namn"]
    
    var sections: [String] = ["Vänförfrågningar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        acceptBtn.layer.cornerRadius = 10
        removeBtn.layer.cornerRadius = 10
        removeBtn.layer.borderWidth = 1
        removeBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = requestData[indexPath.row]
    
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
