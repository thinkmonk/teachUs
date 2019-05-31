//
//  CollegeNotesDetails.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
// MARK: - CollegeNotesDetails
struct CollegeNotesDetails: Codable {
    let classSubjects: [NotesList]?
    
    enum CodingKeys: String, CodingKey {
        case classSubjects = "class_subjects"
    }
}
