//
//  RepeatTableViewCell.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-12-19.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class RepeatTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var dateCellLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
