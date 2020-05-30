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
    var dataSourceObject:Any?
    
    init(detailsCell:AdmissionCellType, detailsObject:Any?, dataSource:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
        self.dataSourceObject = dataSource
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
    var admissionData:AdmissionData!
    static var shared = AdmissionFormManager()
    
    func makePersonalInfoDataSource() -> [AdmissionFormDataSource]{
        var arrayDataSource = [AdmissionFormDataSource]()
        
        let personalInfo = AdmissionFormDataSource(detailsCell: .PersonalInfo, detailsObject: nil, dataSource:nil)
        arrayDataSource.append(personalInfo)
        
        let personalInfoObj = self.admissionData.personalInformation
        
        
        let SureName  = AdmissionFormDataSource(detailsCell: .SureName, detailsObject: personalInfoObj?.surname, dataSource:nil)
        arrayDataSource.append(SureName)
        
        let FirstName  = AdmissionFormDataSource(detailsCell: .FirstName, detailsObject: personalInfoObj?.firstName, dataSource:nil)
        arrayDataSource.append(FirstName)
        
        let FathersName  = AdmissionFormDataSource(detailsCell: .FathersName, detailsObject: personalInfoObj?.fatherName, dataSource:nil)
        arrayDataSource.append(FathersName)
        
        let MothersName  = AdmissionFormDataSource(detailsCell: .MothersName, detailsObject: personalInfoObj?.motherName, dataSource:nil)
        arrayDataSource.append(MothersName)
        
        let NameOnMarkSheet  = AdmissionFormDataSource(detailsCell: .NameOnMarkSheet, detailsObject: personalInfoObj?.fullName, dataSource:nil)
        arrayDataSource.append(NameOnMarkSheet)
        
        let DevnagriName  = AdmissionFormDataSource(detailsCell: .DevnagriName, detailsObject: personalInfoObj?.fullNameDevnagriScript, dataSource:nil)
        arrayDataSource.append(DevnagriName)
        
        let DOB  = AdmissionFormDataSource(detailsCell: .DOB, detailsObject: personalInfoObj?.dob, dataSource:nil)
        arrayDataSource.append(DOB)
        
        let MobileNumber  = AdmissionFormDataSource(detailsCell: .MobileNumber, detailsObject: personalInfoObj?.contact, dataSource:nil)
        arrayDataSource.append(MobileNumber)
        
        let EmailAddress  = AdmissionFormDataSource(detailsCell: .EmailAddress, detailsObject: personalInfoObj?.email, dataSource:nil)
        arrayDataSource.append(EmailAddress)
                
        let cateoryDs = self.admissionData.admissionCategory?.map({$0.categoryName})
        let Category  = AdmissionFormDataSource(detailsCell: .Category, detailsObject: personalInfoObj?.category, dataSource:cateoryDs)
        arrayDataSource.append(Category)
        
        let Gender  = AdmissionFormDataSource(detailsCell: .Gender, detailsObject:personalInfoObj?.gender, dataSource:AdmissionConstantData.genders)
        arrayDataSource.append(Gender)
        
        let Aadhar  = AdmissionFormDataSource(detailsCell: .Aadhar, detailsObject: personalInfoObj?.aadharCard, dataSource:nil)
        arrayDataSource.append(Aadhar)
        
        let Religiion  = AdmissionFormDataSource(detailsCell: .Religiion, detailsObject:personalInfoObj?.religion , dataSource:AdmissionConstantData.religions)
        arrayDataSource.append(Religiion)
        
        let Caste  = AdmissionFormDataSource(detailsCell: .Caste, detailsObject: personalInfoObj?.caste, dataSource:nil)
        arrayDataSource.append(Caste)
        
        let Domicile  = AdmissionFormDataSource(detailsCell: .Domicile, detailsObject:personalInfoObj?.domicileOfState , dataSource:AdmissionConstantData.states)
        arrayDataSource.append(Domicile)
        
        let Nationality  = AdmissionFormDataSource(detailsCell: .Nationality, detailsObject: personalInfoObj?.nationality, dataSource:nil)
        arrayDataSource.append(Nationality)
        
        let MotherTongue  = AdmissionFormDataSource(detailsCell: .MotherTongue, detailsObject:personalInfoObj?.motherTongue , dataSource:AdmissionConstantData.mothertongue)
        arrayDataSource.append(MotherTongue)
        
        let MaritialStatus  = AdmissionFormDataSource(detailsCell: .MaritialStatus, detailsObject:personalInfoObj?.maritalStatus , dataSource:AdmissionConstantData.maritialStatus)
        arrayDataSource.append(MaritialStatus)
        
        let BloodGroup  = AdmissionFormDataSource(detailsCell: .BloodGroup, detailsObject: personalInfoObj?.bloodGroup, dataSource:AdmissionConstantData.bloodGroup)
        arrayDataSource.append(BloodGroup)
                
        return arrayDataSource
    }
    
    func getAddressDataSource(_ isPermanent:Bool) -> [AdmissionFormDataSource]{
        let personalInfoObj = self.admissionData.personalInformation

        var arrayDataSource = [AdmissionFormDataSource]()
        
        let headerDs = isPermanent ? AdmissionFormDataSource(detailsCell: .PermannentAddress, detailsObject: nil, dataSource:nil) : AdmissionFormDataSource(detailsCell: .CorrespondanceAddress, detailsObject: nil, dataSource:nil)
        arrayDataSource.append(headerDs)
        
        
        let roomValue = isPermanent ? personalInfoObj?.permanentAddressRoom : personalInfoObj?.correspondenceAddressRoom
        let roomDs = AdmissionFormDataSource(detailsCell: .RoomFloorBldg, detailsObject: roomValue, dataSource:nil)
        arrayDataSource.append(roomDs)
        
        
        let areaValue = isPermanent ? personalInfoObj?.permanentAddressArea : personalInfoObj?.correspondenceAddressArea
        let areaDs = AdmissionFormDataSource(detailsCell: .AreaLandamrk, detailsObject: areaValue, dataSource:nil)
        arrayDataSource.append(areaDs)
        
        let cityValue = isPermanent ? personalInfoObj?.permanentAddressCity : personalInfoObj?.correspondenceAddressCity
        let cityDS = AdmissionFormDataSource(detailsCell: .City, detailsObject: cityValue, dataSource:nil)
        arrayDataSource.append(cityDS)
        
        let pinValue = isPermanent ? personalInfoObj?.permanentAddressPinCode : personalInfoObj?.correspondenceAddressPinCode
        let pincode = AdmissionFormDataSource(detailsCell: .PinCode, detailsObject: pinValue, dataSource:nil)
        arrayDataSource.append(pincode)
        
        let stateValue = isPermanent ? personalInfoObj?.permanentAddressState : personalInfoObj?.correspondenceAddressState
        let stateDs = AdmissionFormDataSource(detailsCell: .State ,detailsObject:stateValue , dataSource:AdmissionConstantData.states)
        arrayDataSource.append(stateDs)
        
        let countryValue = isPermanent ? personalInfoObj?.permanentAddressCountry : personalInfoObj?.correspondenceAddressCountry
        let country = AdmissionFormDataSource(detailsCell: .Country, detailsObject: countryValue, dataSource:nil)
        arrayDataSource.append(country)
        
        return arrayDataSource
    }
}


//MARK:- PICKER DATA SOURCE

struct AdmissionConstantData{
    //MARK: ------------- PAGE ONE -------------
    static let states = ["Andaman and Nicobar", "Andra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Delhi", "Goa",
    "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Ladakh", "Lakshadweep", "Madya Pradesh", "Maharshtra",
    "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telagana", "Tripura", "Uttaranchal",
    "Uttar Pradesh", "West Bengal", "Others"]
    
    static let bloodGroup = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O"]
    
    static let maritialStatus = ["Single", "Married", "Widowed", "Separated", "Divorced"]
    
    static let mothertongue = ["Assamese", "Bengali", "Bodo", "Dogri", "Gujarati", "Hindi", "Kannada", "Kashmiri", "Konkani", "Malayalam", "Manipuri",
    "Marathi", "Nepali", "Oriya", "Punjabi", "Sanskrit", "Santali", "Sindhi", "Tamil", "Telugu", "Urdu", "Others"]
    
    static let religions = ["Hindu", "Muslim", "Christian", "Jain", "Buddhist", "Sikh", "Parsi", "Jewish", "Zoroastrian", "Others"]
    
    static let genders = ["Male", "Female", "Trans-gender"]
    
    //MARK: ------------- PAGE THREE -------------
    static let academicYear = ["First Year","Second Year","Third Year","Fourth Year","Fifth Year","Six Year"]
    
    static let semsters = ["Semester 1", "Semester 2", "Semester 3", "Semester 4", "Semester 5", "Semester 6",
    "Semester 7", "Semester 8", "Semester 9", "Semester 10", "Semester 11", "Semester 12"]
    
    static let grade = ["O","A","B","C","D","E", "F"]
    
    static let In_house = ["Yes","No"]
    
    static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    static let years  = ["2020","2019","2018","2017","2016","2015","2014","2013","2012","2011"]
    
    static let BacklogNo = ["0","1","2","3","4","5","6","7","8","9","10"]
    
    
    //MARK: -------------  PAGE FOUR -------------
    
    static let professionList = ["Business","Job","Professional","Self-employed","Not employed","Others"]
    
    static let incomeList = ["None","Job","< 2.5 Lakhs","2.5 Lakh - 5 Lakh","5 Lakh - 10 Lakh","> 10 Lakh"]
}
