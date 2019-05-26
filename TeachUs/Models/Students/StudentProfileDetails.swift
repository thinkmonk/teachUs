//
//  StudentProfileDetails.swift
//  TeachUs
//
//  Created by ios on 5/11/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct StudentProfileDetails: Codable {
    let studentDetails: StudentDetails?
    let classDetails: [ClassDetail]?
    let subjectDetails: [SubjectDetail]?
    let collegeDetails: [CollegeDetail]?
    
    enum CodingKeys: String, CodingKey {
        case studentDetails = "student_details"
        case classDetails = "class_details"
        case subjectDetails = "subject_details"
        case collegeDetails = "college_details"
    }
}

struct ClassDetail: Codable {
    let classID, classDivision, year, yearName: String?
    let specialisation, courseID, semester, excelSheetUploadID: String?
    let courseName, courseCode, noOfYears, streamID: String?
    
    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case classDivision = "class_division"
        case year
        case yearName = "year_name"
        case specialisation
        case courseID = "course_id"
        case semester
        case excelSheetUploadID = "excel_sheet_upload_id"
        case courseName = "course_name"
        case courseCode = "course_code"
        case noOfYears = "no_of_years"
        case streamID = "stream_id"
    }
}

struct CollegeDetail: Codable {
    let collegeID, collegeName, address, city: String?
    let universityID, createdOn, collegeCode, dbExist: String?
    let schemaGenerated, uniqueCollegeID, currentYear: String?
    
    enum CodingKeys: String, CodingKey {
        case collegeID = "college_id"
        case collegeName = "college_name"
        case address, city
        case universityID = "university_id"
        case createdOn = "created_on"
        case collegeCode = "college_code"
        case dbExist = "db_exist"
        case schemaGenerated = "schema_generated"
        case uniqueCollegeID = "unique_college_id"
        case currentYear = "current_year"
    }
}

struct StudentDetails: Codable {
    let studentID, rollNumber, fName, lName: String?
    let mName, dob, email, gender: String?
    let contact, classID, createdOn, excelSheetUploadID: String?
    var fullName :String{
        return "\(fName ?? "") \(mName ?? "") \(lName ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case studentID = "student_id"
        case rollNumber = "roll_number"
        case fName = "f_name"
        case lName = "l_name"
        case mName = "m_name"
        case dob, email, gender, contact
        case classID = "class_id"
        case createdOn = "created_on"
        case excelSheetUploadID = "excel_sheet_upload_id"
    }
}

struct SubjectDetail: Codable {
    let studentMapID, studentID, subjectID, classID: String?
    let courseID, excelSheetUploadID, subjectName, subjectCode: String?
    let semester: String?
    
    enum CodingKeys: String, CodingKey {
        case studentMapID = "student_map_id"
        case studentID = "student_id"
        case subjectID = "subject_id"
        case classID = "class_id"
        case courseID = "course_id"
        case excelSheetUploadID = "excel_sheet_upload_id"
        case subjectName = "subject_name"
        case subjectCode = "subject_code"
        case semester
    }
}
