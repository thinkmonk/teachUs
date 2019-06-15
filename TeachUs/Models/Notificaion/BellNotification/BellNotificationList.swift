//
//  BellNotificationList.swift
//  TeachUs
//
//  Created by ios on 6/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

// MARK: - BellNotificationList
struct BellNotificationList: Codable {
    let notifications: [BellNotification]?
    let totalNotification: String?
    
    enum CodingKeys: String, CodingKey {
        case notifications
        case totalNotification = "total_notification"
    }
}

// MARK: - Notification
struct BellNotification: Codable {
    let id: String?
    let data: DataClass?
    let created: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let message: String?
    let androidActivity: String?
    let webPage: String?
    let linkTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case androidActivity = "android_activity"
        case webPage = "web_page"
        case linkTitle = "link_title"
    }
}
