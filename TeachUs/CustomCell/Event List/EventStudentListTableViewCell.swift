//
//  EventStudentListTableViewCell.swift
//  TeachUs
//
//  Created by ios on 4/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class EventStudentListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRollNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonSubtractAttendance: ButtonWithIndexPath!
    @IBOutlet weak var buttonAddAttendance: ButtonWithIndexPath!
    @IBOutlet weak var labelAttendanceCount: UILabel!
    var student : EventStudents!
    var attendanceCount:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonAddAttendance.makeViewCircular()
        self.buttonSubtractAttendance.makeViewCircular()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setUpCellForStudent(student:EventStudents){
        self.student = student
        self.attendanceCount = student.attendance.value
        self.labelRollNumber.text = student.rollNumber
        self.labelName.text = student.fullname
        self.labelAttendanceCount.text = "\(student.attendance.value)"
    }
    
    @IBAction func increaseAttendance(_ sender: Any) {
        self.attendanceCount += 1
        EventAttendanceManager.sharedEventAttendanceManager.increaseAttendance(student: self.student)
        self.labelAttendanceCount.text = "\(self.attendanceCount)"
    }
    
    @IBAction func decreasaseAttendance(_ sender: Any) {
        if(attendanceCount > 0){
            EventAttendanceManager.sharedEventAttendanceManager.decreaseAttendance(student: self.student)
            self.attendanceCount -= 1
            self.labelAttendanceCount.text = "\(self.attendanceCount)"
        }
    }
    
    
}
