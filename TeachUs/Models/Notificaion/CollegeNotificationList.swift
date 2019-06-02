//
//  CollegeNotificationList.swift
//  TeachUs
//
//  Created by ios on 6/3/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct CollegeNotificationList: Codable {
    let notifications: [NotificationList]?
}

// MARK: - Notification
struct NotificationList: Codable {
    let notificationID, title, notificationDescription, fromDate: String?
    let toDate, originalFileName, filePath, generatedFileName: String?
    let universityID: String?
    let collegeID, streamID, classID, roleID: String?
    let activeFlag, createdAt, updatedBy, currentYear: String?
    let courses: String?
    
    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case title
        case notificationDescription = "description"
        case fromDate = "from_date"
        case toDate = "to_date"
        case originalFileName = "original_file_name"
        case filePath = "file_path"
        case generatedFileName = "generated_file_name"
        case universityID = "university_id"
        case collegeID = "college_id"
        case streamID = "stream_id"
        case classID = "class_id"
        case roleID = "role_id"
        case activeFlag = "active_flag"
        case createdAt = "created_at"
        case updatedBy = "updated_by"
        case currentYear = "current_year"
        case courses
    }
}
