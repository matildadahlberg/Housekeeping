//
//  showFriendTableCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-12-16.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class showFriendTableCell: UITableViewCell {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        removeButton.layer.cornerRadius = 10
        removeButton.layer.borderWidth = 1
        removeButton.layer.borderColor = UIColor.black.cgColor
        
        // Configure the view for the selected state
    }
    
    @IBAction func removePressed(_ sender: Any) {
        removeButton.isHidden = true
    }
    
    
}
