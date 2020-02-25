//
//  CollegeNoticeList.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct CollegeNoticeList: Codable {
    var notices: [Notice]?
}

// MARK: - Notice
struct Notice: Codable {
    let noticeID, title, noticeDescription, originalFileName: String?
    let generatedFileName: String?
    let filePath: String?
    let universityID, collegeID, streamID, classID: String?
    let roleID, status, createdAt, updatedAt: String?
    let docSize, courses: String?
    let deleteFlag:DeleteFlag
    
    enum CodingKeys: String, CodingKey {
        case noticeID           = "notice_id"
        case title
        case noticeDescription  = "description"
        case originalFileName   = "original_file_name"
        case generatedFileName  = "generated_file_name"
        case filePath           = "file_path"
        case universityID       = "university_id"
        case collegeID          = "college_id"
        case streamID           = "stream_id"
        case classID            = "class_id"
        case roleID             = "role_id"
        case createdAt          = "created_at"
        case updatedAt          = "updated_at"
        case docSize            = "doc_size"
        case deleteFlag         = "delete_flag"
        case status
        case courses
    }
}


enum DeleteFlag :Codable{
    case defaultFlag
    case currentUser
    case otherUser
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        switch rawValue {
        case 0:
            self = .defaultFlag
        case 1:
            self = .currentUser
        case 2:
            self = .otherUser
        default:
            throw CodingError.unknownValue
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .defaultFlag:
            try container.encode(0)
        case .currentUser:
            try container.encode(1)
        case .otherUser:
            try container.encode(2)
        }
    }
}
