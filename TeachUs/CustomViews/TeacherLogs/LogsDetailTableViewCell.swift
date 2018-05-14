//
//  LOgsDetailTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class LogsDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var viewNumberOfLectures: UIView!
    @IBOutlet weak var labelNumberOfLecs: UILabel!
    
    @IBOutlet weak var viewLecTime: UIView!
    @IBOutlet weak var labelLectureTime: UILabel!
    
    
    @IBOutlet weak var viewAttendance: UIView!
    @IBOutlet weak var labelAttendanceCount: UILabel!
    
    @IBOutlet weak var viewTimeOfSubject: UIView!
    @IBOutlet weak var labelTimeOfSubmission: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
