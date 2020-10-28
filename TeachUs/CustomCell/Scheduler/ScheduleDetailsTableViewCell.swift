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
    case reschedule
}

protocol ScheduleDetailCellDelegate:class {
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath)
    func actionEditSchedule(_ sender: ButtonWithIndexPath)
    func actionJoinSchedule(_ sender: ButtonWithIndexPath)
    func actionReschedule(_ sender: ButtonWithIndexPath)
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
    @IBOutlet weak var buttonReschedule: ButtonWithIndexPath!
    
    weak var delegate : ScheduleDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonReschedule.makeButtonwith(background: Constants.colors.themeBlue, fontColor: .white, cornerRadius: 0, borderColor: UIColor.white.cgColor, borderWidth: 0)
    }
    
    func setUpUI(for cellType:DetaillCellType) {
        buttonReschedule.isHidden = true
        buttonEdit.isHidden = true
        buttonDelete.isHidden = true
        stackViewJoin.isHidden = true

        switch cellType {
        case .lectureDetails:
            buttonEdit.isHidden = false
            buttonDelete.isHidden = false

        case .reschedule:
            buttonEdit.isHidden = false
            buttonReschedule.isHidden = false
            
        case .liveLecture:
            stackViewJoin.isHidden = false
        }
    }
    
    func setUpCell(details: ScheduleDetail, cellType: DetaillCellType) {
        self.setUpUI(for: cellType)
        
        if let fromTime = details.fromTime, let toTime = details.toTime{
            let font = UIFont.boldSystemFont(ofSize: 15)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black,
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

    @IBAction func actionReschedule(_ sender: ButtonWithIndexPath) {
        delegate?.actionReschedule(sender)
    }
    
}
