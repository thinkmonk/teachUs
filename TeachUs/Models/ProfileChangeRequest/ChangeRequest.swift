//
//  ChangeRequest.swift
//  TeachUs
//
//  Created by ios on 5/26/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct ChangeRequest: Codable {
    var requestData: [RequestData]?
    var logArray: [LogArray]?

    enum CodingKeys: String, CodingKey {
        case requestData = "request_data"
        case logArray = "log_array"
    }
}

// MARK: - LogArray
struct LogArray: Codable {
    var subjectName: String?
    var professorName: String?
    var courseName: String?
    var lectureDate: String?
    var noOfLecture: String?
    var fromTime: String?
    var toTime: String?
    var dateOfSubmission: String?
    var attId: String?
    var deleteRequestAttId: String?
    var comment: String?
    var unitList: [UnitSyllabusArray]?
    var totalStudentAttendance: String?
    var requestType: String?
    var userType: String?

    

    enum CodingKeys: String, CodingKey {
        case subjectName = "subject_name"
        case professorName = "professor_name"
        case courseName = "course_name"
        case lectureDate = "lecture_date"
        case noOfLecture = "no_of_lecture"
        case fromTime = "from_time"
        case toTime = "to_time"
        case dateOfSubmission = "date_of_submission"
        case attId = "att_id"
        case deleteRequestAttId = "delete_request_att_id"
        case comment = "comment"
        case unitList = "unit_list"
        case totalStudentAttendance = "total_student_attendance"
        case requestType = "request_type"
        case userType = "user_type"
    }
}


// MARK: - RequestDatum
struct RequestData: Codable {
    var verifyDocumentsId: String?
    var filePath: String?
    var requestType: String?
    var userId: String?
    var userType: String?
    var existingData: String?
    var newData: String?
    var status: String?
    var docSize: String?

    enum CodingKeys: String, CodingKey {
        case verifyDocumentsId = "verify_documents_id"
        case filePath = "file_path"
        case requestType = "request_type"
        case userId = "user_id"
        case userType = "user_type"
        case existingData = "existing_data"
        case newData = "new_data"
        case status = "status"
        case docSize = "doc_size"
    }
}
