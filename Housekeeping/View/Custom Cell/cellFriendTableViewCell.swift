//
//  cellFriendTableViewCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-30.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Firebase

class cellFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptBtn: UIButton!
    
    
    @IBOutlet weak var removeBtn: UIButton!
    
  
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
        acceptBtn.layer.cornerRadius = 10
        removeBtn.layer.cornerRadius = 10
        removeBtn.layer.borderWidth = 1
        removeBtn.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func removePressed(_ sender: Any) {
    }
    

}
