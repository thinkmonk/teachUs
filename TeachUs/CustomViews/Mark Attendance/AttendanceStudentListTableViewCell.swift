//
//  AttendanceStudentListTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/7/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AttendanceStudentListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewProflie: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelRollNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonAttendance: ButtonWithIndexPath!
    
    @IBOutlet weak var viewAttendanceDetails: UIView!
    @IBOutlet weak var labelLastLectureAttendance: UILabel!
    @IBOutlet weak var labelAttendanceCount: UILabel!
    @IBOutlet weak var labelAttendancePercent: UILabel!
    
    var isExpanded:Bool = false
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeTableCellEdgesRounded()
        self.buttonAttendance.makeTableCellEdgesRounded()
        self.buttonAttendance.dropShadow()
        // Initialization code
    }
    
    func setUpCell(){
        if buttonAttendance.isSelected{
            self.buttonAttendance.setTitle("Present", for: .selected)
            self.buttonAttendance.backgroundColor = UIColor.rgbColor(198, 0, 60)
            self.buttonAttendance.setTitleColor(UIColor.white, for: .selected)
        }
        else{
            self.buttonAttendance.setTitle("Absent", for: .normal)
            self.buttonAttendance.backgroundColor = UIColor.rgbColor(126, 132, 155)
            self.buttonAttendance.setTitleColor(UIColor.white, for: .normal)
        }
        self.imageViewProfile.makeViewCircular()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
