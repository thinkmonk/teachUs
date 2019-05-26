//
//  ChangeRequest.swift
//  TeachUs
//
//  Created by ios on 5/26/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct ChangeRequest: Codable {
    let requestData: [RequestData]?
    
    enum CodingKeys: String, CodingKey {
        case requestData = "request_data"
    }
}

// MARK: - RequestDatum
struct RequestData: Codable {
    let verifyDocumentsID, filePath, requestType, userID: String?
    let userType, existingData, newData, status: String?
    let docSize: String?
    
    enum CodingKeys: String, CodingKey {
        case verifyDocumentsID = "verify_documents_id"
        case filePath = "file_path"
        case requestType = "request_type"
        case userID = "user_id"
        case userType = "user_type"
        case existingData = "existing_data"
        case newData = "new_data"
        case status
        case docSize = "doc_size"
    }
}
