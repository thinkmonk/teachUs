//
//  AttendanceDetailsHeaderTableViewCell.swift
//  TeachUs
//
//  Created by ios on 3/21/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class AttendanceDetailsHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelAttendancePercentage: UILabel!
    @IBOutlet weak var labelAttendanceCount: UILabel!
    @IBOutlet weak var stackViewCellBg: UIStackView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.makeTopEdgesRounded()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelSubjectName.textColor = UIColor.white
        self.labelAttendanceCount.textColor = UIColor.white
        self.labelAttendancePercentage.textColor = UIColor.white
        self.backgroundColor = UIColor.rgbColor(5, 41, 107)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
