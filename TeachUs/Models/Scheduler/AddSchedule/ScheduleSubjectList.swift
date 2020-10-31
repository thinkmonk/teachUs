//
//  ScheduleSubjectList.swift
//  TeachUs
//
//  Created by iOS on 17/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

// MARK: - ScheduleSubjectList
struct ScheduleSubjectList: Codable {
    var scheduleSubject: [ScheduleSubject]?
    private var schedules: [ScheduleSubject]?
    enum CodingKeys: String, CodingKey {
        case scheduleSubject = "schedule_subject"
        case schedules = "schedules"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scheduleSubject = try container.decodeIfPresent([ScheduleSubject].self, forKey: .scheduleSubject)
        if (scheduleSubject?.isEmpty ?? true) {
            let schedules = try container.decodeIfPresent([ScheduleSubject].self, forKey: .schedules)
            scheduleSubject = schedules
        }
    }

}

// MARK: - ScheduleSubject
struct ScheduleSubject: Codable {
    var subjectId: String?
    var subjectName: String?
    var className: String?
    var classId: String?

    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case className = "class_name"
        case classId = "class_id"
    }

}
