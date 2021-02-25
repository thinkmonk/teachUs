//
//  ScheduleProfile.swift
//  TeachUs
//
//  Created by iOS on 21/02/21.
//  Copyright © 2021 TeachUs. All rights reserved.
//

import Foundation

// MARK: - ScheduleProfiles
struct ScheduleProfiles: Codable {
    var arraySchedulesProfile: [SchedulesProfile]?

    enum CodingKeys: String, CodingKey {
        case arraySchedulesProfile = "schedules_profile"
    }
}

// MARK: - SchedulesProfile
struct SchedulesProfile: Codable {
    var scheduleProfileDetailsId: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case scheduleProfileDetailsId = "schedule_profile_details_id"
        case email = "email"
    }
}
