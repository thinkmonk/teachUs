//
//  OfflineAttendanceManager.swift
//  TeachUs
//
//  Created by ios on 7/22/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class OfflineAttendanceManager {
    
    static let sharedAttendanceManager = OfflineAttendanceManager()
    
    var arrayStudents : Variable<[MarkStudentAttendance]> = Variable([])
    let disposeBag = DisposeBag()
    var presentCount:Int {
        let presentStudent = arrayStudents.value.filter{$0.isPrsent == true}
        return presentStudent.count
    }
    
    func markStudentPresent(studentDetails:MarkStudentAttendance){
        arrayStudents.value.filter{$0.offlineStudent?.student_id! == studentDetails.offlineStudent?.student_id!}.first?.isPrsent = true
    }
    
    func markStudentAbsent(studentDetails:MarkStudentAttendance){
        arrayStudents.value.filter{$0.offlineStudent?.student_id! == studentDetails.offlineStudent?.student_id!}.first?.isPrsent = false
    }
    
    var offlineAttendanceList:String {
        var attendance = ""
        let presentStudents = self.arrayStudents.value.filter{$0.isPrsent == true}
        for student in presentStudents{
            attendance.append("\((student.offlineStudent?.student_id!)!),")
        }
        return attendance
    }
}
