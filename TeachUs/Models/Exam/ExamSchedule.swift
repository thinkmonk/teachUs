//
//  ExamSchedule.swift
//  TeachUs
//
//  Created by iOS on 19/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
// MARK: - ExamSchedule
struct ExamSchedule: Codable {
    var status: Bool?
    var message: String?
    var data: [ScheduleData]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }
}

// MARK: - Datum
struct ScheduleData: Codable {
    var paperId: String?
    var subjectName: String?
    var modifiedOn: String?
    var expiryDate: String?
    var takenTest: String?
    var startTime: String?
    var endTime: String?

    enum CodingKeys: String, CodingKey {
        case paperId = "PaperID"
        case subjectName = "SubjectName"
        case modifiedOn = "ModifiedOn"
        case expiryDate = "ExpiryDate"
        case takenTest = "TakenTest"
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}
