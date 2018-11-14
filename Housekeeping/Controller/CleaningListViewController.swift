//
//  CleaningListViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-12.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

var cleanArray = ["Varje dag: ","Varje vecka: ","Varje månad: ","Var 3-6 månad: ","Varje år: "]

class CleaningListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cleanArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = cleanArray[indexPath.row]
        
        return cell
    }



}
