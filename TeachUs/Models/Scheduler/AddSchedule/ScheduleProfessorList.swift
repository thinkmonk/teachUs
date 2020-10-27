//
//  ScheduleProfessorList.swift
//  TeachUs
//
//  Created by iOS on 17/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

// MARK: - ScheduleProfessorList
struct ScheduleProfessorList: Codable {
    var scheduleProfessor: [ScheduleProfessor]?

    enum CodingKeys: String, CodingKey {
        case scheduleProfessor = "schedule_professor"
    }
}

// MARK: - ScheduleProfessor
struct ScheduleProfessor: Codable {
    var professorId: String?
    var professorName: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case professorId = "professor_id"
        case professorName = "professor_name"
        case email = "email"
    }
}
