//
//  CollegeProfSubjectDetials.swift
//  TeachUs
//
//  Created by ios on 3/16/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct ProfessorSubjectList: Codable {
    var subjectsDetails: [SubjectsDetail]
    
    enum CodingKeys: String, CodingKey {
        case subjectsDetails = "subjects_details"
    }
}

struct SubjectsDetail: Codable {
    let subjectID, subjectName, classID: String
    
    enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case subjectName = "subject_name"
        case classID = "class_id"
    }
}
