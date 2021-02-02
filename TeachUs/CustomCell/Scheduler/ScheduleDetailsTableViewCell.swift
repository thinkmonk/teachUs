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
    case professorHost
    case professorLiveLecture
    case professorRecordAttendance
    case professorLectureWillStart
    case professorDefault
    case studentSchedule
    case parentsSchedule
}

protocol ScheduleDetailCellDelegate:class {
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath)
    func actionEditSchedule(_ sender: ButtonWithIndexPath)
    func actionJoinSchedule(_ sender: ButtonWithIndexPath)
    func actionReschedule(_ sender: ButtonWithIndexPath)
    func actionStart(_ sender: ButtonWithIndexPath)
    func actionRecordAttendance(_ sender: ButtonWithIndexPath)
}

extension ScheduleDetailCellDelegate {
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath)
    {
        /*
         base method
         */
    }
    
    func actionEditSchedule(_ sender: ButtonWithIndexPath) {
        /*
         base method
         */
    }
    
    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        /*
         base method
         */
    }
    
    func actionReschedule(_ sender: ButtonWithIndexPath) {
        /*
         base method
         */
    }
    
    func actionStart(_ sender: ButtonWithIndexPath) {
        /*
         base method
        */
    }
    
    func actionRecordAttendance(_ sender: ButtonWithIndexPath) {
        /*
         base method
        */
    }

}

class ScheduleDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageviewProfessor: UIImageView!
    @IBOutlet weak var labelLectureTiming: UILabel!
    @IBOutlet weak var labelLectureMode: UILabel!
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelProfessorName: UILabel!
    @IBOutlet weak var buttonDelete: ButtonWithIndexPath!
    @IBOutlet weak var buttonJoin: ButtonWithIndexPath!
    @IBOutlet weak var buttonEdit: ButtonWithIndexPath!
    @IBOutlet weak var buttonReschedule: ButtonWithIndexPath!
    @IBOutlet weak var buttonRecordAttendance: ButtonWithIndexPath!
    @IBOutlet weak var buttonStartLecture: ButtonWithIndexPath!
    
    weak var delegate : ScheduleDetailCellDelegate?
    private var details:ScheduleDetail?
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonReschedule.indexPath = nil
        buttonDelete.indexPath = nil
        buttonJoin.indexPath = nil
        buttonEdit.indexPath = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonReschedule.makeButtonwith(background: Constants.colors.themeMainBlue, fontColor: .white, cornerRadius: 0, borderColor: UIColor.white.cgColor, borderWidth: 0)
        buttonJoin.makeButtonwith(background: Constants.colors.themeMainBlue, fontColor: .white, cornerRadius: 0, borderColor: UIColor.white.cgColor, borderWidth: 0)
        buttonRecordAttendance.makeButtonwith(background: Constants.colors.themeRed, fontColor: .white, cornerRadius: 0, borderColor: UIColor.white.cgColor, borderWidth: 0)
        buttonStartLecture.makeButtonwith(background: Constants.colors.themeMainBlue, fontColor: .white, cornerRadius: 0, borderColor: UIColor.white.cgColor, borderWidth: 0)

    }
    
    func setUpUI(for cellType:DetaillCellType) {
        buttonReschedule.isHidden = true
        buttonEdit.isHidden = true
        buttonDelete.isHidden = true
        buttonJoin.isHidden = true
        buttonRecordAttendance.isHidden = true
        buttonStartLecture.isHidden = true
        imageviewProfessor.isHidden = true


        switch cellType {
        case .lectureDetails:
            buttonEdit.isHidden = false
            buttonDelete.isHidden = false
            imageviewProfessor.isHidden = false

        case .reschedule:
            buttonEdit.isHidden = false
            buttonReschedule.isHidden = false
            
        case .liveLecture:
            buttonJoin.isHidden = false
            
        case .professorHost:
            labelProfessorName.isHidden = true
            buttonStartLecture.isHidden = false
            
        case .professorRecordAttendance:
            labelProfessorName.isHidden = true
            buttonRecordAttendance.isHidden = false
            
        case .professorLectureWillStart:
            buttonEdit.isHidden = false
            buttonDelete.isHidden = false
            labelProfessorName.isHidden = true
            
        case .professorLiveLecture:
            labelProfessorName.isHidden = true
            buttonJoin.isHidden = false
            buttonRecordAttendance.isHidden = false

        case .professorDefault:
            labelProfessorName.isHidden = true

        case .studentSchedule:
            buttonJoin.isHidden = !((details?.scheduleStatus ?? "") == "1")
            
        case .parentsSchedule:
            break
        }
    }
    
    func setUpCell(details: ScheduleDetail, cellType: DetaillCellType) {
        self.setUpUI(for: cellType)
        self.details = details
        if let fromTime = details.fromTime, let toTime = details.toTime {
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
    
    @IBAction func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        delegate?.actionJoinSchedule(sender)

    }

    @IBAction func actionReschedule(_ sender: ButtonWithIndexPath) {
        delegate?.actionReschedule(sender)
    }
    
    @IBAction func actionEdit(_ sender: ButtonWithIndexPath) {
        delegate?.actionEditSchedule(sender)
    }
    
    @IBAction func actionRecordAttendance(_ sender: ButtonWithIndexPath) {
        delegate?.actionRecordAttendance(sender)
    }
    
    @IBAction func actionStartLecture(_ sender: ButtonWithIndexPath) {
        delegate?.actionStart(sender)

    }
}
