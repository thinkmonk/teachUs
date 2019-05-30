//
//  StudentNotesSubjectList.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct StudentNotesSubjectList: Codable {
    let subjectList: [StudentSubjectList]?
    
    enum CodingKeys: String, CodingKey {
        case subjectList = "subject_list"
    }
}

// MARK: - SubjectList
struct StudentSubjectList: Codable {
    let subjectID, subjectName: String?
    let totalNotes: Int?
    let professorName: String?
    
    enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case subjectName = "subject_name"
        case totalNotes = "total_notes"
        case professorName = "professor_name"
    }
}
