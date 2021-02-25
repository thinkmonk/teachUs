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

//MARK: - OngoingSchedule
struct OnGoingSchedules: Codable {
    var schedules: [ScheduleDetail]?

    enum CodingKeys: String, CodingKey {
        case schedules = "schedules"
    }
}

// MARK: - Schedule
struct Schedule: Codable {
    var classId: String?
    var scheduleClass: String?
    var todaysSchedule: String?
    var totalSchedules: String?
    var subjectId: String?
    var subjectName: String?
    var date: String?  //👈🏼 For Schedule Details
    var scheduleDetails: [ScheduleDetail]?  //👈🏼 For Schedule Details


    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case scheduleClass = "class"
        case todaysSchedule = "todays_schedule"
        case totalSchedules = "total_schedules"
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case date = "date" //👈🏼 For Schedule Details
        case scheduleDetails = "schedule_details" //👈🏼 For Schedule Details
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
    var scheduleURL:String?
    var scheduleHostURL: String?
    var deleteFlag:String?
    var scheduleStatus:String?
    var scheduleType:String?
    var scheduleProfileDetailsId: String?

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
        case scheduleURL = "client_url"
        case scheduleHostURL = "host_url"
        case deleteFlag = "delete_flag"
        case scheduleStatus = "schedule_status"
        case scheduleType = "schedule_type"
        case scheduleProfileDetailsId = "schedule_profile_details_id"
    }
    
    var cellType:DetaillCellType {
        guard let lectureDateObj = lectureDate?.convertToDate("YYYY-MM-dd"),
              let startTimeDate = self.fromTime?.timeToDate(format: "HH:mm:s", for: lectureDateObj),
              let endTimeDate = self.toTime?.timeToDate(format: "HH:mm:s", for: lectureDateObj),
              let statusString = scheduleStatus,
              let scheduleStatus = Int(statusString) else {
            return .professorDefault
        }
        let calendar = Calendar.current
        let startTimeComponents = calendar.dateComponents([.hour, .minute], from: startTimeDate) //1.15
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())//1.45
        let date = Date()
        
        switch scheduleStatus {
        case 0:
            if date <= startTimeDate {
                let difference = (calendar.dateComponents([.minute], from: nowComponents, to: startTimeComponents).minute ?? 0)
                return difference <= 15  && difference >= 0 ?  .professorHost : .professorLectureWillStart
            }
            else if date > startTimeDate && date < endTimeDate {
                return .professorHost
            }
            return .professorDefault
        case 1:
            if date > startTimeDate && date < endTimeDate {
                return .professorLiveLecture
            }else if date > endTimeDate {
                return .professorRecordAttendance
            }
            return .professorHost
            
        case 2:
            return .professorDefault
            
        default:
            return .professorDefault
        }
        
    }
}
