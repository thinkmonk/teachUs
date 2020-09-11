//
//  CollegeSchedule.swift
//  TeachUs
//
//  Created by iOS on 12/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
struct CollegeSchedule: Codable {
    var schedules: [Schedule]?

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
    var date: String?  //👈🏼 For Schedule Details
    var scheduleDetails: [ScheduleDetail]?  //👈🏼 For Schedule Details


    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case scheduleClass = "class"
        case todaysSchedule = "todays_schedule"
        case totalSchedules = "total_schedules"
        case date = "date" //👈🏼 For Schedule Details
        case scheduleDetails = "schedule_details" //👈🏼 For Schedule Details
        
    }
}
