//
//  SyllabusStatusTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/19/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class SyllabusStatusTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var labelNumberOfLectures: UILabel!
    @IBOutlet weak var labelAttendancePercent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeTableCellEdgesRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
