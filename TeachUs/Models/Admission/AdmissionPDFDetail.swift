//
//  AdmissionPDFDetail.swift
//  TeachUs
//
//  Created by iOS on 07/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
// MARK: - AdmissionPdfDetails
struct AdmissionPdfDetails: Codable {
    var status: Int?
    var message: String?
    var pdfUrl: String?
    var admissionStatus: String?
    var feeStatus: String?
    var bankDetails: BankDetails?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case pdfUrl = "pdf_url"
        case admissionStatus = "admission_status"
        case feeStatus = "fee_status"
        case bankDetails = "bank_details"
    }
}

// MARK: - BankDetails
struct BankDetails: Codable {
    var accountNumber: String?
    var ifscCode: String?
    var holderName: String?
    var upi: String?

    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case ifscCode = "ifsc_code"
        case holderName = "holder_name"
        case upi = "upi"
    }
}
