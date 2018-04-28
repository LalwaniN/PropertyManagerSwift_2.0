//
//  FeedbackTableViewCell.swift
//  propertyManagerFinalProject
//
//  Created by Chintan Dinesh Koticha on 4/24/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedbackNameLabel: UILabel!
    @IBOutlet weak var feedbackTextLabel: UILabel!
    @IBOutlet weak var oneStarImgView: UIImageView!
    @IBOutlet weak var twoStarsImgView: UIImageView!
    @IBOutlet weak var threeStarImgView: UIImageView!
    @IBOutlet weak var fourStarsImgView: UIImageView!
    @IBOutlet weak var fiveStarsImgView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Methods
    func updateViewForRating(rating: Int) {
        let arrayOfImages: [UIImageView?] = [oneStarImgView, twoStarsImgView, threeStarImgView, fourStarsImgView, fiveStarsImgView]
        
        for i in 0 ..< rating {
            let imgView = arrayOfImages[i]!
            imgView.isHidden = false
        }
        
        for i in rating ..< arrayOfImages.count {
            let imgView = arrayOfImages[i]!
            imgView.isHidden = true
        }
    }
}
