//
//  ScheduleDateTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 13/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class ScheduleDateTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelDate.textColor = UIColor.rgbColor(110, 110, 110)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
