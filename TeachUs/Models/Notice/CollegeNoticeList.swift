//
//  CollegeNoticeList.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct CollegeNoticeList: Codable {
    let notices: [Notice]?
}

// MARK: - Notice
struct Notice: Codable {
    let noticeID, title, noticeDescription, originalFileName: String?
    let generatedFileName: String?
    let filePath: String?
    let universityID, collegeID, streamID, classID: String?
    let roleID, status, createdAt, updatedAt: String?
    let docSize, courses: String?
    
    enum CodingKeys: String, CodingKey {
        case noticeID = "notice_id"
        case title
        case noticeDescription = "description"
        case originalFileName = "original_file_name"
        case generatedFileName = "generated_file_name"
        case filePath = "file_path"
        case universityID = "university_id"
        case collegeID = "college_id"
        case streamID = "stream_id"
        case classID = "class_id"
        case roleID = "role_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case docSize = "doc_size"
        case courses
    }
}
