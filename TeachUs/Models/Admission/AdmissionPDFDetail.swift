//
//  AdmissionPDFDetail.swift
//  TeachUs
//
//  Created by iOS on 07/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
// MARK: - AdmissionPdfDetails
// MARK: - AdmissionPdfDetails
struct AdmissionPdfDetails: Codable {
    var status: Int?
    var message: String?
    var pdfUrl: String?
    var admissionFormId: String?
    var admissionStatus: String?
    var admissionStatusText: String?
    var feeAmount: String?
    var bankDetails: BankDetails?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case pdfUrl = "pdf_url"
        case admissionFormId = "admission_form_id"
        case admissionStatus = "admission_status"
        case admissionStatusText = "admission_status_text"
        case feeAmount = "fee_amount"
        case bankDetails = "bank_details"
    }
}

// MARK: - BankDetails
struct BankDetails: Codable {
    var accountNumber: String?
    var ifscCode: String?
    var holderName: String?
    var upi: String?
    var branch: String?
    var bankName: String?
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case ifscCode = "ifsc_code"
        case holderName = "holder_name"
        case upi = "upi"
        case branch = "branch"
        case bankName = "bank_name"
    }
}
