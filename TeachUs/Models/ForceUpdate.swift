//
//  ForceUpdate.swift
//  TeachUs
//
//  Created by ios on 3/30/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct ForceUpdate: Codable {
    let deviceUpdate: [DeviceUpdate]?
    
    enum CodingKeys: String, CodingKey {
        case deviceUpdate = "device_update"
    }
}

struct DeviceUpdate: Codable {
    var osType: String?
    var version: String?
    var isForceUpdate: String?
    var studentRating: String?
    var parentRating: String?
    var professorRating: String?
    var collegeRating: String?
    var studentMaintenance: String?
    var parentMaintenance: String?
    var professorMaintenance: String?
    var collegeMaintenance: String?
    var studentLogout: String?
    var professorLogout: String?
    var parentLogout: String?
    var collegeLogout: String?
    var appUpdateText:String = "Latest version is waiting for you. Please update the application now!"
    var forceUpdateText:String = "All set for the newest experience of your own App! Please update the application now!"
    var forceUpdateTextTitle:String = "Heads up!"


    enum CodingKeys: String, CodingKey {
        case osType = "os_type"
        case version = "version"
        case isForceUpdate = "is_force_update"
        case studentRating = "student_rating"
        case parentRating = "parent_rating"
        case professorRating = "professor_rating"
        case collegeRating = "college_rating"
        case studentMaintenance = "student_maintenance"
        case parentMaintenance = "parent_maintenance"
        case professorMaintenance = "professor_maintenance"
        case collegeMaintenance = "college_maintenance"
        case studentLogout = "student_logout"
        case professorLogout = "professor_logout"
        case parentLogout = "parent_logout"
        case collegeLogout = "college_logout"
    }
}
