//
//  StudentAttendanceDetails.swift
//  TeachUs
//
//  Created by ios on 3/23/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct AttendanceDetails: Codable {
    let attendanceData: [AttendanceData]?
    let totalLectureAttended, totalLecturesTaken, percent: String?
    
    enum CodingKeys: String, CodingKey {
        case attendanceData = "attendance_data"
        case totalLectureAttended = "total_lecture_attended"
        case totalLecturesTaken = "total_lectures_taken"
        case percent
    }
}

struct AttendanceData: Codable {
    let date, lecturesAttended, lecturesTaken: String?
    
    enum CodingKeys: String, CodingKey {
        case date
        case lecturesAttended = "lectures_attended"
        case lecturesTaken = "lectures_taken"
    }
}
