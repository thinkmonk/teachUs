//
//  AdmissionSubjectData.swift
//  TeachUs
//
//  Created by iOS on 31/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

// MARK: - AdmissioSubjectData

struct AdmissioSubjectData: Codable {
    var admissionForm: [AdmissionForm]?

    enum CodingKeys: String, CodingKey { //parent entity will hold all the details of available streams
        case admissionForm = "admission_form"
    }
}
struct AdmissionSingleFormSubjectData:Codable{
    var admissionForm: AdmissionForm?
    
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
    var isPreferenceFlow: String?
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
    var subjectSelected: AdmissionSubject?
    var defaultSubjectList: AdmissionSubject? //locally renamed

    enum CodingKeys: String, CodingKey {
        case classMasterId = "class_master_id"
        case collegeId = "college_id"
        case collegeClassId = "college_class_id"
        case className = "class_name"
        case specilaization = "specilaization"
        case isPreferenceFlow = "is_preference_flow"
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
        case subjectSelected = "subjectSelected"
        case defaultSubjectList = "subjectList"
    }
}

// MARK: - Subject
struct AdmissionSubject: Codable {
    var semester3: AdmissionSemester?
    var semester4: AdmissionSemester?
    var semester5: AdmissionSemester?
    var semester6: AdmissionSemester?

    enum CodingKeys: String, CodingKey {
        case semester3 = "Semester 3"
        case semester4 = "Semester 4"
        case semester5 = "Semester 5"
        case semester6 = "Semester 6"
    }
}

// MARK: - Semester
struct AdmissionSemester: Codable {
    var subjectList: [AdmnissionSubjectList]?
    var maxSubject: String?
    var optionalSubjectCount: String?
    var maxPreferenceCount: String?
    var preferenceList: [PreferenceList]?

    enum CodingKeys: String, CodingKey {
        case subjectList = "subject_list"
        case maxSubject = "max_subject"
        case optionalSubjectCount = "optional_subject_count"
        case maxPreferenceCount = "max_preference_count"
        case preferenceList = "preference_list"
    }
}

// MARK: - PreferenceList
struct PreferenceList: Codable {
    var subjectId: String?
    var subjectName: String?
    var semester: String?
    var mandatory: String?
    var preference:String?
    
    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case semester = "semester"
        case mandatory = "mandatory"
        case preference = "preference"

    }
}

// MARK: - SubjectList
struct AdmnissionSubjectList: Codable {
    var subjectId: String?
    var subjectName: String?
    var collegeId: String?
    var classId: String?
    var semester: String?
    var mandatory: String?
    var preference:String?


    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case collegeId = "college_id"
        case classId = "class_id"
        case semester = "semester"
        case mandatory = "mandatory"
        case preference = "preference"
    }
}


/// TO be sent to server
struct AdmissionSubjectFormForAPI:Codable{
    var level: String?
    var courseFullName: String?
    var className: String?
    var collegeClassId: String?
    var academicYesr: String?
    var subject:[AdmissionFormSubject]?
    
    enum CodingKeys: String, CodingKey {
         case level = "level"
         case courseFullName = "course_full_name"
         case className =  "class_name"
         case collegeClassId = "class_id"
         case academicYesr = "academic_year"
         case subject = "subject"
    }

}

struct AdmissionFormSubject:Codable{
    var subjectId: String?
    var subjectName: String?
    var semester: String?
    var preference:String? = "0"
    var mandatory: String?
    var optionalSubjectRank:String?
    
    enum CodingKeys: String, CodingKey {
        case subjectId = "subject_id"
        case subjectName = "subject_name"
        case semester = "semester"
        case preference = "preference"
    }

}
