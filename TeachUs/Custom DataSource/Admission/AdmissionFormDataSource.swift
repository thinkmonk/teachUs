//
//  AdmissionFormDataSource.swift
//  TeachUs
//
//  Created by iOS on 28/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

enum AdmissionCellType:String {
    case PersonalInfo           = "Personal information"
    case SureName               = "Surname"
    case FirstName              = "First Name"
    case FathersName            = "Father's Name"
    case MothersName            = "Mother's Name"
    case NameOnMarkSheet        = "Name as per last qualifying examination marksheet"
    case DevnagriName           = "Full name in devnagri script"
    case DOB                    = "Date of birth"
    case MobileNumber           = "Mobile number"
    case EmailAddress           = "Email address"
    case Category               = "Admission category"
    case Gender                 = "Gender"
    case Aadhar                 = "AADHAR number"
    case Religiion              = "Religion"
    case Caste                  = "Caste"
    case Domicile               = "Domicile of state"
    case Nationality            = "Nationality"
    case MotherTongue           = "Mother Tongue"
    case MaritialStatus         = "Maritial Status"
    case BloodGroup             = "Blood Group"
    case CorrespondanceAddress  = "Correspondence address"
    case RoomFloorBldg          = "Room no, Floor, Building, Street"
    case AreaLandamrk           = "Area, Landmark, Station"
    case City                   = "City"
    case PinCode                = "Pin Code"
    case State                  = "State"
    case Country                = "Country"
    case PermannentAddress      = "Permanent Address"
    
//    var placeHolder:String{
//        switch self {
//        case .SureName:
//        case .FirstName:
//        case .FathersName:
//        case .MothersName:
//        case .NameOnMarkSheet:
//        case .DevnagriName:
//        case .DOB:
//        case .MobileNumber:
//        case .EmailAddress:
//        case .PersonalInfo:
//        case .Category:
//        case .Gender:
//        case .Aadhar:
//        case .Religiion:
//        case .Caste:
//        case .Domicile:
//        case .Nationality:
//        case .MotherTongue:
//        case .MaritialStatus:
//        case .BloodGroup:
//        case .CorrespondanceAddress:
//        case .RoomFloorBldg:
//        case .AreaLandamrk:
//        case .City:
//        case .PinCode:
//        case .Country:
//        case .PermannentAddress :
//
//
//        }
//    }
}

enum FormSections{
    case Profile
    case CorrespondingAddress
    case PermanenttAddress
}

class AdmissionFormSectionDataSource{
    var sectionType:FormSections
    var attachedObj:[AdmissionFormDataSource]
    var rowCount:Int!
    
    init(sectionType:FormSections, obj:[AdmissionFormDataSource]) {
        self.sectionType = sectionType
        self.attachedObj = obj
        rowCount = obj.count
    }
}


class AdmissionFormDataSource{
    var cellType:AdmissionCellType!
    var attachedObject:Any?
    var dataSourceObject:Any?
    
    init(detailsCell:AdmissionCellType, detailsObject:Any?, dataSource:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
        self.dataSourceObject = dataSource
    }
    
}

extension AdmissionFormDataSource{
    func setValues(value:String, otherObj:Any?, ispermanenetAddress:Bool){
        let personalinfo = AdmissionFormManager.shared.admissionData.personalInformation
        switch  self.cellType {
        case .SureName:
            personalinfo?.surname = value
        case .some(.FirstName):
            personalinfo?.firstName = value
        case .some(.FathersName):
            personalinfo?.fatherName = value
        case .some(.MothersName):
            personalinfo?.motherName = value
        case .some(.NameOnMarkSheet):
            personalinfo?.fullName = value
        case .some(.DevnagriName):
            personalinfo?.fullNameDevnagriScript = value
        case .some(.DOB):
            personalinfo?.dob = value
        case .some(.MobileNumber):
            personalinfo?.contact = value
        case .some(.EmailAddress):
            personalinfo?.email = value
        case .some(.Category):
            personalinfo?.category = value
        case .some(.Gender):
            personalinfo?.gender = value
        case .some(.Aadhar):
            personalinfo?.aadharCard = value
        case .some(.Religiion):
            personalinfo?.religion = value
        case .some(.Caste):
            personalinfo?.caste = value
        case .some(.Domicile):
            personalinfo?.domicileOfState = value
        case .some(.Nationality):
            personalinfo?.nationality = value
        case .some(.MotherTongue):
            personalinfo?.motherTongue = value
        case .some(.MaritialStatus):
            personalinfo?.maritalStatus = value
        case .some(.BloodGroup):
            personalinfo?.bloodGroup = value
        case .some(.RoomFloorBldg):
            if ispermanenetAddress {
                personalinfo?.permanentAddressRoom = value
            }else{
                personalinfo?.correspondenceAddressRoom = value
            }
        case .some(.AreaLandamrk):
            if ispermanenetAddress {
                personalinfo?.permanentAddressArea = value
            }else{
                personalinfo?.correspondenceAddressArea = value
            }
        case .some(.City):
            if ispermanenetAddress {
                personalinfo?.permanentAddressCity = value
            }else{
                personalinfo?.correspondenceAddressCity = value
            }
        case .some(.PinCode):
            if ispermanenetAddress {
                personalinfo?.permanentAddressPinCode = value
            }else{
                personalinfo?.correspondenceAddressPinCode = value
            }
        case .some(.State):
            if ispermanenetAddress {
                personalinfo?.permanentAddressState = value
            }else{
                personalinfo?.correspondenceAddressState = value
            }
        case .some(.Country):
            if ispermanenetAddress {
                personalinfo?.permanentAddressCountry = value
            }else{
                personalinfo?.correspondenceAddressCountry = value
            }
            
        default:
            break
        }
    }

}
