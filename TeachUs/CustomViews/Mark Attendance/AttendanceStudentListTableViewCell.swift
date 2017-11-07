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
    @IBOutlet weak var buttonAttendance: UIButton!
    
    @IBOutlet weak var viewAttendanceDetails: UIView!
    @IBOutlet weak var labelLastLectureAttendance: UILabel!
    @IBOutlet weak var labelAttendanceCount: UILabel!
    @IBOutlet weak var labelAttendancePercent: UILabel!
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonAttendance.setTitle("Present", for: .selected)
        self.buttonAttendance.setTitle("Absent", for: .normal)
        // Initialization code
    }
    
    func setUpRx(){
        self.buttonAttendance.rx.tap.subscribe(onNext:{[unowned self] in
            if self.buttonAttendance.isSelected{
                self.buttonAttendance.backgroundColor = UIColor.rgbColor(198, 0, 60)
            }
            else{
                self.buttonAttendance.backgroundColor = UIColor.rgbColor(126, 132, 155)
            }
        }).disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
