//
//  AttendanceDetailsValuesTableViewCell.swift
//  TeachUs
//
//  Created by ios on 3/21/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class AttendanceDetailsValuesTableViewCell: UITableViewCell {
    @IBOutlet weak var stackViewCellBg: UIStackView!
    @IBOutlet weak var viewSeperatorBottom: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLecturesAtteended: UILabel!
    @IBOutlet weak var labelLecturesTaken: UILabel!
    @IBOutlet weak var viewcellBg: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
