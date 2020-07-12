//
//  AdmissionDocuments.swift
//  TeachUs
//
//  Created by iOS on 06/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
// MARK: - AdmissionDocuments
struct AdmissionDocuments: Codable {
    var personalInformation: PersonalDocumentInformation?

    enum CodingKeys: String, CodingKey {
        case personalInformation = "personal_information"
    }
}

// MARK: - PersonalInformation
struct PersonalDocumentInformation: Codable {
    var id: String?
    var photo: String?
    var sign: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case photo = "photo"
        case sign = "sign"
    }
}
