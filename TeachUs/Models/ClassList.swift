//
//  ClassList.swift
//  TeachUs
//
//  Created by ios on 4/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper


/*
"class_list": [
{
"class_id": "1",
"class_division": "A",
"year": "1",
"year_name": "FY",
"specialisation": "Finance",
"course_id": "1",
"semester": "1",
"course_name": "FYBMS",
"total_participants": "19"
}
]

*/

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let classListObj = try? newJSONDecoder().decode(ClassListObj.self, from: jsonData)

import Foundation

// MARK: - ClassListObj
struct ClassListObj: Codable {
    var deleteStatus: DeleteFlag?
    var classList: [ClassList]?

    enum CodingKeys: String, CodingKey {
        case deleteStatus = "delete_status"
        case classList = "class_list"
    }
}

// MARK: - ClassList
struct ClassList: Codable {
    var classId: String?
    var classDivision: String?
    var year: String?
    var yearName: String?
    var specialisation: String?
    var courseId: String?
    var semester: String?
    var excelSheetUploadId: String?
    var commanumberRollnumber: String?
    var courseName: String?
    var totalParticipants: String?

    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case classDivision = "class_division"
        case year = "year"
        case yearName = "year_name"
        case specialisation = "specialisation"
        case courseId = "course_id"
        case semester = "semester"
        case excelSheetUploadId = "excel_sheet_upload_id"
        case commanumberRollnumber = "commanumber_rollnumber"
        case courseName = "course_name"
        case totalParticipants = "total_participants"
    }
}
