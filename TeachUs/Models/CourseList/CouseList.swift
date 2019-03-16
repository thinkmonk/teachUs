//
//  CouseList.swift
//  TeachUs
//
//  Created by ios on 3/9/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct CourseDetails: Codable {
    let courseList: [CourseList]
    
    enum CodingKeys: String, CodingKey {
        case courseList = "course_list"
    }
}

struct CourseList: Codable {
    let courseID, courseName, courseCode, noOfYears: String
    let streamID: String
    let excelSheetUploadID: String?
    
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case courseName = "course_name"
        case courseCode = "course_code"
        case noOfYears = "no_of_years"
        case streamID = "stream_id"
        case excelSheetUploadID = "excel_sheet_upload_id"
    }
}

/*
typealias CourseDetails = [CourseDetail]

struct CourseDetail: Codable {
    let courseID, courseName, courseCode, noOfYears: String
    let streamID: String
    let excelSheetUploadID: String?
    
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case courseName = "course_name"
        case courseCode = "course_code"
        case noOfYears = "no_of_years"
        case streamID = "stream_id"
        case excelSheetUploadID = "excel_sheet_upload_id"
    }
}
*/
