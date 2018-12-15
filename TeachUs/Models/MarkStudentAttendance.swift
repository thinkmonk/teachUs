//
//  StudentAttendance.swift
//  TeachUs
//
//  Created by ios on 11/11/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
class MarkStudentAttendance {
    var student : EnrolledStudentDetail?
    var isPrsent:Bool!
    
    init(_ studentDetail:EnrolledStudentDetail, _ isStudentPresent:Bool) {
        self.student = studentDetail
        self.isPrsent = isStudentPresent
    }


    var offlineStudent:Offline_Student_list?
    init(offlineStudentDetail:Offline_Student_list, _ isStudentPresent:Bool) {
        self.offlineStudent = offlineStudentDetail
        self.isPrsent = isStudentPresent
    }
}
