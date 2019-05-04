//
//  AttendanceManager.swift
//  TeachUs
//
//  Created by ios on 11/11/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AttendanceManager {
    
    static let sharedAttendanceManager = AttendanceManager()
    var arrayStudents : Variable<[MarkStudentAttendance]> = Variable([])
    let disposeBag = DisposeBag()
    var presentCount:Int {
        let presentStudent = arrayStudents.value.filter{$0.isPrsent == true}
        return presentStudent.count
    }
    
    func markStudentPresent(studentDetails:MarkStudentAttendance){
        arrayStudents.value.filter{$0.student?.studentId == studentDetails.student?.studentId}.first?.isPrsent = true
    }
    
    func markStudentAbsent(studentDetails:MarkStudentAttendance){
        arrayStudents.value.filter{$0.student?.studentId! == studentDetails.student?.studentId!}.first?.isPrsent = false
    }
    
    var attendanceList:String {
        var attendance:[String] = []
        let presentStudents = self.arrayStudents.value.filter{$0.isPrsent == true}
        
        for student in presentStudents{
            attendance.append("\((student.student?.studentId!)!)")
        }
        return attendance.joined(separator: ",")
    }
}


