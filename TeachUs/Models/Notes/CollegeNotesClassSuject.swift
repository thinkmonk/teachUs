//
//  CollegeNotesClassSuject.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct CollegeNotesClassSuject: Codable {
    var classSubjetcs: [ClassProfessorNotes]?
    
    enum CodingKeys: String, CodingKey {
        case classSubjetcs = "class_subjetcs"
    }
}

// MARK: - ClassSubjetc
struct ClassProfessorNotes: Codable {
    let subjectID, subjectName, classSubjetcClass, professorName: String?
    let totalNotes, profile, professorID: String?
    
    enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case subjectName = "subject_name"
        case classSubjetcClass = "class"
        case professorName = "professor_name"
        case totalNotes = "total_notes"
        case profile
        case professorID = "professor_id"
    }
}
