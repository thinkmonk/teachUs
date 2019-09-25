//
//  ParentDetails.swift
//  TeachUs
//
//  Created by ios on 9/24/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct ParentsDetails: Codable {
    let parentsDetails: ParentsDetailsClass
    let student: [StudentProfileDetails]
    
    enum CodingKeys: String, CodingKey {
        case parentsDetails = "parents_details"
        case student
    }
}

// MARK: - ParentsDetailsClass
struct ParentsDetailsClass: Codable {
    let roleID, collegeID, privilege, collegeName: String
    let collegeCode, roleName: String
    
    enum CodingKeys: String, CodingKey {
        case roleID = "role_id"
        case collegeID = "college_id"
        case privilege
        case collegeName = "college_name"
        case collegeCode = "college_code"
        case roleName = "role_name"
    }
}
