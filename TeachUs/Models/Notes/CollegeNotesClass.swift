//
//  CollegeNotesClass.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
// MARK: - NotesClass
struct NotesClass: Codable {
    var classSubjects: [ClassSubject]?
    
    enum CodingKeys: String, CodingKey {
        case classSubjects = "class_subjects"
    }
}

// MARK: - ClassSubject
struct ClassSubject: Codable {
    let classID, classSubjectClass, totalSubject: String?
    
    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case classSubjectClass = "class"
        case totalSubject = "total_subject"
    }
}
