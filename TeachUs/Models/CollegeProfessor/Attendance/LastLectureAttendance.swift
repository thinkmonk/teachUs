//
//  LastLectureAttendance.swift
//  TeachUs
//
//  Created by ios on 9/14/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation


struct LastLectureAttendance: Codable {
    let lastAttendanceDetail: [LastAttendanceDetail]
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case lastAttendanceDetail = "last_attendance_detail"
        case status
    }
}

// MARK: - LastAttendanceDetail
struct LastAttendanceDetail: Codable {
    let studentID, attStatus: String
    
    enum CodingKeys: String, CodingKey {
        case studentID = "student_id"
        case attStatus = "att_status"
    }
}
