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

    enum CodingKeys: String, CodingKey {
        case scheduleSubject = "schedule_subject"
    }
}

// MARK: - ScheduleSubject
struct ScheduleSubject: Codable {
    var subjectId: String?
    var subjectName: String?

    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
    }
}
