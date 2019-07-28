//
//  BellNotificationReadStatus.swift
//  TeachUs
//
//  Created by ios on 7/28/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct BellNotificationReadStatus: Codable {
    let status: Int?
    let message, totalNotification: String?
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case totalNotification = "total_notification"
    }
}
