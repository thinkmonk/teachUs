//
//  ProfessorProfileDetails.swift
//  TeachUs
//
//  Created by ios on 5/27/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct ProfessorProfileDetails: Codable {
    let professorDetails: ProfessorProfile?
    let data: [Datum]?
    
    enum CodingKeys: String, CodingKey {
        case professorDetails = "professor_details"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    let collegeName, collegeCode, privilege, role: String?
    let courses, rolePrivilege: String?
    let courseDetails: [CourseDetail]?
    
    enum CodingKeys: String, CodingKey {
        case collegeName = "college_name"
        case collegeCode = "college_code"
        case privilege, role, courses
        case rolePrivilege = "role_privilege"
        case courseDetails = "course_details"
    }
}

// MARK: - CourseDetail
struct CourseDetail: Codable {
    let courseName: String?
    let subjects: [String]?
    let classDivision: String?
    let yearName: String?
    let year, semester: String?
    
    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case subjects
        case classDivision = "class_division"
        case yearName = "year_name"
        case year, semester
    }
}

// MARK: - ProfessorDetails
struct ProfessorProfile: Codable {
    let id, fName, email, contact: String?
    let uniqueLoginID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fName = "f_name"
        case email, contact
        case uniqueLoginID = "unique_login_id"
    }
}
