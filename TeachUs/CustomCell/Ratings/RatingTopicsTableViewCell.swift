//
//  RatingTopicsTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class RatingTopicsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRatingTopic: UILabel!    
    @IBOutlet weak var buttonShowInfo: ButtonWithIndexPath!
    @IBOutlet weak var buttonRating: ButtonWithIndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeTableCellEdgesRounded()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  makeWhiteBackground(_ value:Bool){
        self.buttonRating.backgroundColor = value ? UIColor.white : UIColor.rgbColor(235.0, 235.0, 235.0)
    }
}
