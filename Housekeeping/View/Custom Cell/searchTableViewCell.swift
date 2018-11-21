//
//  searchTableViewCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-20.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class searchTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func addFriendBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var buttonStyle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonStyle.layer.cornerRadius = 10
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
