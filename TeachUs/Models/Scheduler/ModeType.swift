//
//  ModeType.swift
//  TeachUs
//
//  Created by iOS on 06/12/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation


// MARK: - ScheduleModeType
struct ScheduleModeType: Codable {
    var scheduleModes: [ScheduleMode]?

    enum CodingKeys: String, CodingKey {
        case scheduleModes = "schedule"
    }
}

// MARK: - Schedule
struct ScheduleMode: Codable {
    var scheduleType: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case scheduleType = "schedule_type"
        case name = "name"
    }
}
