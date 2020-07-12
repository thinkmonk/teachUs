//
//  AdmissionData.swift
//  TeachUs
//
//  Created by iOS on 27/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class AdmissionData: Codable {
    var personalInformation: PersonalInformation?
    var admissionCategory: [AdmissionCategory]?


    
    enum CodingKeys: String, CodingKey {
        case personalInformation = "personal_information"
        case admissionCategory = "admission_category"
    }
}

// MARK: - AdmissionCategory
class AdmissionCategory: Codable {
    var admissionCategoryId: String?
    var collegeId: String?
    var categoryName: String?

    enum CodingKeys: String, CodingKey {
        case admissionCategoryId = "admission_category_id"
        case collegeId = "college_id"
        case categoryName = "category_name"
    }
}

// MARK: - PersonalInformation
class PersonalInformation: Codable {
    var id: String?
    var surname: String?
    var firstName: String?
    var fatherName: String?
    var motherName: String?
    var dob: String?
    var contact: String?
    var email: String?
    var category: String?
    var gender: String?
    var aadharCard: String?
    var religion: String?
    var nationality: String?
    var motherTongue: String?
    var maritalStatus: String?
    var bloodGroup: String?
    var fullName: String?
//    var fullNameDevnagriScript: String?
    var correspondenceAddressRoom: String?
    var correspondenceAddressArea: String?
    var correspondenceAddressCity: String?
    var correspondenceAddressPinCode: String?
    var correspondenceAddressState: String?
    var correspondenceAddressCountry: String?
    var permanentAddressRoom: String?
    var permanentAddressArea: String?
    var permanentAddressCity: String?
    var permanentAddressPinCode: String?
    var permanentAddressState: String?
    var permanentAddressCountry: String?
    var caste: String?
    var domicileOfState: String?
    
    
//    func validateClassData() -> Bool{
//        let tempObj = Mirror(reflecting: self as Any)
//        return !tempObj.children.contains(where: { (label, value) -> Bool in
//            if case Optional<Any>.none = value{
//                return true
//            }
//            return false
//        })
//    }
    
    
    func validateClassData() -> Bool{
        return !(self.surname?.isEmpty ?? true) &&
            !(self.firstName?.isEmpty ?? true) &&
            !(self.fatherName?.isEmpty ?? true) &&
            !(self.motherName?.isEmpty ?? true) &&
            !(self.fullName?.isEmpty ?? true) &&
            !(self.dob?.isEmpty ?? true) &&
            !(self.email?.isEmpty ?? true) &&
            !(self.category?.isEmpty ?? true) &&
            !(self.gender?.isEmpty ?? true) &&
            !(self.aadharCard?.isEmpty ?? true) &&
            !(self.religion?.isEmpty ?? true) &&
            !(self.domicileOfState?.isEmpty ?? true) &&
            !(self.nationality?.isEmpty ?? true) &&
            !(self.motherTongue?.isEmpty ?? true) &&
            !(self.maritalStatus?.isEmpty ?? true) &&
            !(self.correspondenceAddressRoom?.isEmpty ?? true) &&
            !(self.correspondenceAddressArea?.isEmpty ?? true) &&
            !(self.correspondenceAddressCity?.isEmpty ?? true) &&
            !(self.correspondenceAddressPinCode?.isEmpty ?? true) &&
            !(self.correspondenceAddressState?.isEmpty ?? true) &&
            !(self.correspondenceAddressCountry?.isEmpty ?? true) &&
            !(self.permanentAddressRoom?.isEmpty ?? true) &&
            !(self.permanentAddressArea?.isEmpty ?? true) &&
            !(self.permanentAddressCity?.isEmpty ?? true) &&
            !(self.permanentAddressPinCode?.isEmpty ?? true) &&
            !(self.permanentAddressState?.isEmpty ?? true) &&
            !(self.permanentAddressCountry?.isEmpty ?? true)
    }
        


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case surname = "surname"
        case firstName = "first_name"
        case fatherName = "father_name"
        case motherName = "mother_name"
        case dob = "dob"
        case contact = "contact"
        case email = "email"
        case category = "category"
        case gender = "gender"
        case aadharCard = "aadhar_card"
        case religion = "religion"
        case nationality = "nationality"
        case motherTongue = "mother_tongue"
        case maritalStatus = "marital_status"
        case bloodGroup = "blood_group"
        case fullName = "f_name"
//        case fullNameDevnagriScript = "f_name_devnagri_script"
        case correspondenceAddressRoom = "correspondence_address_room"
        case correspondenceAddressArea = "correspondence_address_area"
        case correspondenceAddressCity = "correspondence_address_city"
        case correspondenceAddressPinCode = "correspondence_address_pin_code"
        case correspondenceAddressState = "correspondence_address_state"
        case correspondenceAddressCountry = "correspondence_address_country"
        case permanentAddressRoom = "permanent_address_room"
        case permanentAddressArea = "permanent_address_area"
        case permanentAddressCity = "permanent_address_city"
        case permanentAddressPinCode = "permanent_address_pin_code"
        case permanentAddressState = "permanent_address_state"
        case permanentAddressCountry = "permanent_address_country"
        case caste = "caste"
        case domicileOfState = "domicile_of_state"
    }
}
