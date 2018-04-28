//
//  HotDealsTableViewCell.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/27/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class HotDealsTableViewCell: UITableViewCell {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
