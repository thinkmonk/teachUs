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
    
    init(_ student:EnrolledStudentDetail, _ isPresent:Bool) {
        self.student = student
        self.isPrsent = isPresent
    }
}
