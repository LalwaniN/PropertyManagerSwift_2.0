//
//  ChatScreenTableViewCell.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/27/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class ChatScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
