//
//  NotesSubjectDetails.swift
//  TeachUs
//
//  Created by ios on 5/28/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct NotesSubjectDetails: Codable {
    let notesList: [NotesList]?
    
    enum CodingKeys: String, CodingKey {
        case notesList = "notes_list"
    }
}

// MARK: - NotesList
struct NotesList: Codable {
    let notesID, title, originalFileName, generatedFileName: String?
    let filePath: String?
    let universityID, collegeID, streamID, classID: String?
    let subjectID, createdAt, updatedAt, status: String?
    let professorID, docSize: String?
    
    enum CodingKeys: String, CodingKey {
        case notesID = "notes_id"
        case title
        case originalFileName = "original_file_name"
        case generatedFileName = "generated_file_name"
        case filePath = "file_path"
        case universityID = "university_id"
        case collegeID = "college_id"
        case streamID = "stream_id"
        case classID = "class_id"
        case subjectID = "subject_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case professorID = "professor_id"
        case docSize = "doc_size"
    }
}
