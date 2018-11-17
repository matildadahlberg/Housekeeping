//
//  CustomTableViewCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-15.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameCell: UILabel!
    @IBOutlet weak var eventtitleCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
