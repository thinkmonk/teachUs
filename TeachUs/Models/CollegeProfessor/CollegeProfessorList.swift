//
//  CollegeProfessorList.swift
//  TeachUs
//
//  Created by ios on 3/16/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct CollegeProfessorList: Codable {
    var professorSubjects: [ProfessorSubject]
    
    enum CodingKeys: String, CodingKey {
        case professorSubjects = "professor_subjects"
    }
}

struct ProfessorSubject: Codable {
    let professorID, professorName, subjects, profile: String?
    
    enum CodingKeys: String, CodingKey {
        case professorID = "professor_id"
        case professorName = "professor_name"
        case subjects, profile
    }
}
