//
//  ScheduleDetailsTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 13/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

enum DetaillCellType{
    case lectureDetails
    case liveLecture
}

protocol ScheduleDetailCellDelegate:class {
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath)
    func actionEditSchedule(_ sender: ButtonWithIndexPath)
    func actionJoinSchedule(_ sender: ButtonWithIndexPath)
}

class ScheduleDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelLectureTiming: UILabel!
    @IBOutlet weak var labelLectureMode: UILabel!
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelProfessorName: UILabel!
    @IBOutlet weak var stactViewEditAndDelete: UIStackView!
    @IBOutlet weak var stackViewJoin: UIStackView!
    @IBOutlet weak var buttonDelete: ButtonWithIndexPath!
    @IBOutlet weak var buttonJoin: ButtonWithIndexPath!
    @IBOutlet weak var buttonEdit: ButtonWithIndexPath!
    
    weak var delegate : ScheduleDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(details: ScheduleDetail, cellType: DetaillCellType) {
        stackViewJoin.isHidden = cellType == .lectureDetails
        
        if let fromTime = details.fromTime, let toTime = details.toTime{
            let font = UIFont.boldSystemFont(ofSize: 14)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.darkGray,
            ]

            let firstString = NSMutableAttributedString(string: fromTime.convert24hrTimeto12Hr(), attributes: attributes)
            let secondString = NSAttributedString(string: " to ")
            let thirdString = NSAttributedString(string: toTime.convert24hrTimeto12Hr(), attributes: attributes)
            firstString.append(secondString)
            firstString.append(thirdString)
            labelLectureTiming.attributedText = firstString
        }
        
        labelLectureMode.text = details.attendanceType ?? ""
        labelSubjectName.text = details.subjectName ?? ""
        labelProfessorName.text = details.professorName ?? ""
    }
    
    @IBAction func actionDeleteSchedule(_ sender: ButtonWithIndexPath) {
        delegate?.actionDeleteSchedule(sender)
    }
    
    @IBAction func actionEditSchedule(_ sender: ButtonWithIndexPath) {
        delegate?.actionEditSchedule(sender)

    }
    
    @IBAction func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        delegate?.actionJoinSchedule(sender)

    }


}
