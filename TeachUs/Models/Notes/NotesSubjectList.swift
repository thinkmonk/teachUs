//
//  NotesSubjectList.swift
//  TeachUs
//
//  Created by ios on 5/27/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

struct NotesSubjectList: Codable {
    var subjectList: [SubjectList]?
    
    enum CodingKeys: String, CodingKey {
        case subjectList = "subject_list"
    }
}

// MARK: - SubjectList
struct SubjectList: Codable {
    let subjectID: String?
    let subjectListClass: String?
    let subjectName: String?
    let totalNotes: Int?
    let classID: String?
    
    enum CodingKeys: String, CodingKey {
        case subjectID = "subject_id"
        case subjectListClass = "class"
        case subjectName = "subject_name"
        case totalNotes = "total_notes"
        case classID = "class_id"
    }
}
