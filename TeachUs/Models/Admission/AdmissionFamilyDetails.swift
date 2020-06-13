//
//  AdmissionFamilyDetails.swift
//  TeachUs
//
//  Created by iOS on 05/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let admissionFamilyDetails = try? newJSONDecoder().decode(AdmissionFamilyDetails.self, from: jsonData)

import Foundation

// MARK: - AdmissionFamilyDetails
struct AdmissionFamilyDetails: Codable {
    var familyDetailsInformation: FamilyDetailsInformation?

    enum CodingKeys: String, CodingKey {
        case familyDetailsInformation = "family_details_information"
    }
}

// MARK: - FamilyDetailsInformation
struct FamilyDetailsInformation: Codable {
    var admissionFormId: String?
    var collegeId: String?
    var loginId: String?
    var fatherFullName: String?
    var fatherAge: String?
    var fatherDob: String?
    var fatherContactNumber: String?
    var fatherEmail: String?
    var fatherProfession: String?
    var fatherIndustry: String?
    var fatherTotalIncome: String?
    var fatherCounty: String?
    var motherFullName: String?
    var motherAge: String?
    var motherDob: String?
    var motherContactNumber: String?
    var motherEmail: String?
    var motherProfession: String?
    var motherIndustry: String?
    var motherTotalIncome: String?
    var motherCountry: String?
    var classId: String?
    var className: String?
    var isPreferenceFlow: String?
    var admissionStatus: String?
    var feeStatus: String?
    var preferenceStatus: String?
    
    var isDataPresent:Bool{
        return !(self.fatherDob?.isEmpty ?? true) &&
        !(self.fatherContactNumber?.isEmpty ?? true) &&
        !(self.fatherProfession?.isEmpty ?? true) &&
        !(self.fatherTotalIncome?.isEmpty ?? true) &&
        !(self.fatherCounty?.isEmpty ?? true) &&
        !(self.motherDob?.isEmpty ?? true) &&
        !(self.motherContactNumber?.isEmpty ?? true) &&
        !(self.motherProfession?.isEmpty ?? true) &&
        !(self.motherTotalIncome?.isEmpty ?? true) &&
        !(self.motherCountry?.isEmpty ?? true)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case admissionFormId = "admission_form_id"
        case collegeId = "college_id"
        case loginId = "login_id"
        case fatherFullName = "father_full_name"
        case fatherAge = "father_age"
        case fatherDob = "father_dob"
        case fatherContactNumber = "father_contact_number"
        case fatherEmail = "father_email"
        case fatherProfession = "father_profession"
        case fatherIndustry = "father_industry"
        case fatherTotalIncome = "father_total_income"
        case fatherCounty = "father_county"
        case motherFullName = "mother_full_name"
        case motherAge = "mother_age"
        case motherDob = "mother_dob"
        case motherContactNumber = "mother_contact_number"
        case motherEmail = "mother_email"
        case motherProfession = "mother_profession"
        case motherIndustry = "mother_industry"
        case motherTotalIncome = "mother_total_income"
        case motherCountry = "mother_country"
        case classId = "class_id"
        case className = "class_name"
        case isPreferenceFlow = "is_preference_flow"
        case admissionStatus = "admission_status"
        case feeStatus = "fee_status"
        case preferenceStatus = "preference_status"
    }
}
