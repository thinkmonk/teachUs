//
//  ClassScheduleDetails.swift
//  TeachUs
//
//  Created by iOS on 12/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
struct ClassScheduleDetails: Codable {
    var schedules: [Schedule]?

    enum CodingKeys: String, CodingKey {
        case schedules = "schedules"
    }
}

// MARK: - ScheduleDetail
struct ScheduleDetail: Codable {
    var attendanceScheduleId: String?
    var lectureDate: String?
    var fromTime: String?
    var toTime: String?
    var professorId: String?
    var professorName: String?
    var professorEmail: String?
    var subjectId: String?
    var subjectName: String?
    var classId: String?
    var className: String?
    var attendanceType: String?

    enum CodingKeys: String, CodingKey {
        case attendanceScheduleId = "attendance_schedule_id"
        case lectureDate = "lecture_date"
        case fromTime = "from_time"
        case toTime = "to_time"
        case professorId = "professor_id"
        case professorName = "professor_name"
        case professorEmail = "professor_email"
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case classId = "class_id"
        case className = "class_name"
        case attendanceType = "attendance_type"
    }
}
