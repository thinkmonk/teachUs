//
//  ExamScheduleTableViewCell.swift
//  TeachUs
//
//  Created by iOS on 19/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class ExamScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var labelSubjectName: UILabel!
    @IBOutlet weak var labelExamDate: UILabel!
    @IBOutlet weak var labelExamTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(with examData:ScheduleData) {
        labelSubjectName.text = "Subject: \(examData.subjectName ?? "")"
        let dateString = examData.expiryDate?.convertToDateString(format: "dd MMM yyyy") ?? "NA"
        labelExamDate.text = "Date: \(dateString)"
        if let fromTime = examData.startTime, let toTime = examData.endTime{
            let font = UIFont.boldSystemFont(ofSize: 14)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let firstString  = NSMutableAttributedString(string: "Time: ")
            let secondString = NSAttributedString(string: fromTime, attributes: attributes)
            let thirdString  = NSAttributedString(string: " to ")
            let fouthString  = NSAttributedString(string: toTime, attributes: attributes)
            firstString.append(secondString)
            firstString.append(thirdString)
            firstString.append(fouthString)
            labelExamTime.attributedText = firstString
        }
    }
}
