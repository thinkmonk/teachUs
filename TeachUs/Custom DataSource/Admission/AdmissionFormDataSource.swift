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

class AdmissionFormDataSource{
    var cellType:AdmissionCellType!
    var attachedObject:Any?
    
    init(detailsCell:AdmissionCellType, detailsObject:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
    }
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


class AdmissionFormManager{
    static var shared = AdmissionFormManager()
    
    func makePersonalInfoDataSource() -> [AdmissionFormDataSource]{
        var arrayDataSource = [AdmissionFormDataSource]()
        
        let personalInfo = AdmissionFormDataSource(detailsCell: .PersonalInfo, detailsObject: nil)
        arrayDataSource.append(personalInfo)
        
        let SureName  = AdmissionFormDataSource(detailsCell: .SureName, detailsObject: nil)
        arrayDataSource.append(SureName)
        
        let FirstName  = AdmissionFormDataSource(detailsCell: .FirstName, detailsObject: nil)
        arrayDataSource.append(FirstName)
        
        let FathersName  = AdmissionFormDataSource(detailsCell: .FathersName, detailsObject: nil)
        arrayDataSource.append(FathersName)
        
        let MothersName  = AdmissionFormDataSource(detailsCell: .MothersName, detailsObject: nil)
        arrayDataSource.append(MothersName)
        
        let NameOnMarkSheet  = AdmissionFormDataSource(detailsCell: .NameOnMarkSheet, detailsObject: nil)
        arrayDataSource.append(NameOnMarkSheet)
        
        let DevnagriName  = AdmissionFormDataSource(detailsCell: .DevnagriName, detailsObject: nil)
        arrayDataSource.append(DevnagriName)
        
        let DOB  = AdmissionFormDataSource(detailsCell: .DOB, detailsObject: nil)
        arrayDataSource.append(DOB)
        
        let MobileNumber  = AdmissionFormDataSource(detailsCell: .MobileNumber, detailsObject: nil)
        arrayDataSource.append(MobileNumber)
        
        let EmailAddress  = AdmissionFormDataSource(detailsCell: .EmailAddress, detailsObject: nil)
        arrayDataSource.append(EmailAddress)
                
        let Category  = AdmissionFormDataSource(detailsCell: .Category, detailsObject: nil)
        arrayDataSource.append(Category)
        
        let Gender  = AdmissionFormDataSource(detailsCell: .Gender, detailsObject: nil)
        arrayDataSource.append(Gender)
        
        let Aadhar  = AdmissionFormDataSource(detailsCell: .Aadhar, detailsObject: nil)
        arrayDataSource.append(Aadhar)
        
        let Religiion  = AdmissionFormDataSource(detailsCell: .Religiion, detailsObject: nil)
        arrayDataSource.append(Religiion)
        
        let Caste  = AdmissionFormDataSource(detailsCell: .Caste, detailsObject: nil)
        arrayDataSource.append(Caste)
        
        let Domicile  = AdmissionFormDataSource(detailsCell: .Domicile, detailsObject: nil)
        arrayDataSource.append(Domicile)
        
        let Nationality  = AdmissionFormDataSource(detailsCell: .Nationality, detailsObject: nil)
        arrayDataSource.append(Nationality)
        
        let MotherTongue  = AdmissionFormDataSource(detailsCell: .MotherTongue, detailsObject: nil)
        arrayDataSource.append(MotherTongue)
        
        let MaritialStatus  = AdmissionFormDataSource(detailsCell: .MaritialStatus, detailsObject: nil)
        arrayDataSource.append(MaritialStatus)
        
        let BloodGroup  = AdmissionFormDataSource(detailsCell: .BloodGroup, detailsObject: nil)
        arrayDataSource.append(BloodGroup)
                
        return arrayDataSource
    }
    
    func getAddressDataSource(_ isPermanent:Bool) -> [AdmissionFormDataSource]{
        var arrayDataSource = [AdmissionFormDataSource]()
        
        
        let headerDs = isPermanent ? AdmissionFormDataSource(detailsCell: .PermannentAddress, detailsObject: nil) : AdmissionFormDataSource(detailsCell: .CorrespondanceAddress, detailsObject: nil)
        arrayDataSource.append(headerDs)
        
        let roomDs = AdmissionFormDataSource(detailsCell: .RoomFloorBldg, detailsObject: nil)
        arrayDataSource.append(roomDs)
        
        let areaDs = AdmissionFormDataSource(detailsCell: .AreaLandamrk, detailsObject: nil)
        arrayDataSource.append(areaDs)
        
        let cityDS = AdmissionFormDataSource(detailsCell: .City, detailsObject: nil)
        arrayDataSource.append(cityDS)
        
        let pincode = AdmissionFormDataSource(detailsCell: .PinCode, detailsObject: nil)
        arrayDataSource.append(pincode)
        
        let stateDs = AdmissionFormDataSource(detailsCell: .State ,detailsObject: nil)
        arrayDataSource.append(stateDs)
        
        let country = AdmissionFormDataSource(detailsCell: .Country, detailsObject: nil)
        arrayDataSource.append(country)
        
        return arrayDataSource
    }
}
