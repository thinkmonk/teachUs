//
//  AdmissionSubjectData.swift
//  TeachUs
//
//  Created by iOS on 31/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
struct AdmissioSubjectnData: Codable {
    var admissionForm: [AdmissionForm]?

    enum CodingKeys: String, CodingKey {
        case admissionForm = "admission_form"
    }
}

// MARK: - AdmissionForm
struct AdmissionForm: Codable {
    var classMasterId: String?
    var collegeId: String?
    var collegeClassId: String?
    var className: String?
    var specilaization: String?
    var maxSubjectForm1: String?
    var maxSubjectForm2: String?
    var level: String?
    var discipline: String?
    var durationOfDegree: String?
    var courseFullName: String?
    var mediumOfInstruction: String?
    var schemeOfExam: String?
    var markingSystem: String?
    var admissionStartDate: String?
    var admissionEndDate: String?
    var examSubmitStatus: String?
    var admissionFeeStatus: String?
    var subject: AdmissionSubject?
    var subjectList: AdmissionSubjectList?

    enum CodingKeys: String, CodingKey {
        case classMasterId = "class_master_id"
        case collegeId = "college_id"
        case collegeClassId = "college_class_id"
        case className = "class_name"
        case specilaization = "specilaization"
        case maxSubjectForm1 = "max_subject_form1"
        case maxSubjectForm2 = "max_subject_form2"
        case level = "level"
        case discipline = "discipline"
        case durationOfDegree = "duration_of_degree"
        case courseFullName = "course_full_name"
        case mediumOfInstruction = "medium_of_instruction"
        case schemeOfExam = "scheme_of_exam"
        case markingSystem = "marking_system"
        case admissionStartDate = "admission_start_date"
        case admissionEndDate = "admission_end_date"
        case examSubmitStatus = "exam_submit_status"
        case admissionFeeStatus = "admission_fee_status"
    }
}

// MARK: - Subject
struct AdmissionSubject: Codable {
    var semester3: [SubjectSemester3]?
    var semester4: [SubjectSemester3]?

    enum CodingKeys: String, CodingKey {
        case semester3 = "Semester 3"
        case semester4 = "Semester 4"
    }
}

// MARK: - SubjectSemester3
struct SubjectSemester3: Codable {
    var subjectId: String?
    var subjectName: String?
    var semester: String?
    var mandatory: String?

    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case semester = "semester"
        case mandatory = "mandatory"
    }
}

// MARK: - SubjectList
struct AdmissionSubjectList: Codable {
    var semester3: [SubjectListSemester3]?
    var semester4: [SubjectListSemester3]?

    enum CodingKeys: String, CodingKey {
        case semester3 = "Semester 3"
        case semester4 = "Semester 4"
    }
}

// MARK: - SubjectListSemester3
struct SubjectListSemester3: Codable {
    var subjectId: String?
    var subjectName: String?
    var collegeId: String?
    var classId: String?
    var semester: String?
    var mandatory: String?

    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case collegeId = "college_id"
        case classId = "class_id"
        case semester = "semester"
        case mandatory = "mandatory"
    }
}
