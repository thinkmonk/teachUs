//
//  AcademicRecord.swift
//  TeachUs
//
//  Created by iOS on 01/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
// MARK: - AdmissionAcademicRecord
struct AdmissionAcademicRecord: Codable {
    var academicRecord: AcademicRecord?
    var admissionGrade: [AdmissionGrade]?

    enum CodingKeys: String, CodingKey {
        case academicRecord = "academic_record"
        case admissionGrade = "admission_grade"
    }
}

// MARK: - AcademicRecord
struct AcademicRecord: Codable {
    var nameOfDegree: String?
    var mediumOfInstructions: String?
    var schemeOfExamination: String?
    var durationOfDegree: String?
    var discipline: String?
    var universityName: String?
    var instituteName: String?
    var markingSystem: String?
    var prnNo: String?
    var inHouse: String?
    var result: [Result]?

    enum CodingKeys: String, CodingKey {
        case nameOfDegree = "name_of_degree"
        case mediumOfInstructions = "medium_of_instructions"
        case schemeOfExamination = "scheme_of_examination"
        case durationOfDegree = "duration_of_degree"
        case discipline = "discipline"
        case universityName = "university_name"
        case instituteName = "institute_name"
        case markingSystem = "marking_system"
        case prnNo = "prn_no"
        case inHouse = "in_house"
        case result = "result"
    }
}

// MARK: - Result
struct Result: Codable {
    var academicYear: String? = ""
    var academicSemester: String? = ""
    var marks: String? = ""
    var creditEarned: String? = ""
    var grade: String? = ""
    var passingMonth: String? = ""
    var passingYear: String? =  ""
    var noOfAtkt: String? =  ""
    var resultStatus: String? =  ""

    enum CodingKeys: String, CodingKey {
        case academicYear = "academic_year"
        case academicSemester = "academic_semester"
        case marks = "marks"
        case creditEarned = "credit_earned"
        case grade = "grade"
        case passingMonth = "passing_month"
        case passingYear = "passing_year"
        case noOfAtkt = "no_of_atkt"
        case resultStatus = "result_status"
    }
}

// MARK: - AdmissionGrade
struct AdmissionGrade: Codable {
    var admissionGradeId: String?
    var collegeId: String?
    var admissionGrade: String?

    enum CodingKeys: String, CodingKey {
        case admissionGradeId = "admission_grade_id"
        case collegeId = "college_id"
        case admissionGrade = "admission_grade"
    }
}
