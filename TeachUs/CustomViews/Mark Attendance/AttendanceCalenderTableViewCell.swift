//
//  AttendanceCalenderTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/6/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class AttendanceCalenderTableViewCell: UITableViewCell {
    @IBOutlet weak var textFieldFromTime: UITextField!
    @IBOutlet weak var textFieldToTime: UITextField!
    @IBOutlet weak var textFieldNumberOfLectures: UITextField!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
