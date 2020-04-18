//
//  AttendanceTimeSlots.swift
//  TeachUs
//
//  Created by iOS on 18/04/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
struct AttendancetimeSlots: Codable {
    var attendanceSlot: [AttendanceSlot]?

    enum CodingKeys: String, CodingKey {
        case attendanceSlot = "attendance_slot"
    }
}

// MARK: - AttendanceSlot
struct AttendanceSlot: Codable {
    var attendanceSlotId: String?
    var classId: String?
    var fromTime: String?
    var toTime: String?

    enum CodingKeys: String, CodingKey {
        case attendanceSlotId = "attendance_slot_id"
        case classId = "class_id"
        case fromTime = "from_time"
        case toTime = "to_time"
    }
}
