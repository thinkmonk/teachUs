//
//  StudentProfileTableViewCell.swift
//  TeachUs
//
//  Created by ios on 3/31/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class StudentProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelRollNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAttendanceCount: UILabel!
    @IBOutlet weak var labelAttendancePercent: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageViewProfile.makeViewCircular()
        self.makeTableCellEdgesRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
