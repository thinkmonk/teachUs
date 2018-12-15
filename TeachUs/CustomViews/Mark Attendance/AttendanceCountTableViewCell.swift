//
//  AttendanceCountTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/11/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class AttendanceCountTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAttendanceCount: UILabel!
    
    @IBOutlet weak var labelPresent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
