//
//  AdmissionFamilyDetailsDataSource.swift
//  TeachUs
//
//  Created by iOS on 05/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
enum AcademicFamilyCellType:String{
    case FamilyDetailsSection = "Family Details"
    case fathersDetails         = "Father's Details"
    case fullName               = "Full name"
    case DOB                    = "Date of birth"
    case age                    = "age"
    case contactNumber          = "Contact number"
    case emailAddress           = "Email address"
    case profession             = "Profession"
    case industry               = "Industry"
    case totalIncome            = "Total Income"
    case countryOfWork          = "Country (of work)"
    case mothersDetails         = "Mother's Details"
}

enum FamilySectionType{
    case header
    case father
    case mother
}


class FamilySectionCellData{
    var headerType: FamilySectionType!
    var attachedObj = [FamilyCellDataSource]()
    var rowCount:Int!
    
    init(type:FamilySectionType, attachedObj:Any?) {
        self.headerType = type
        if let `attachedObj` = attachedObj as? [FamilyCellDataSource]{
            self.attachedObj = attachedObj
            rowCount = attachedObj.count
        }else{
            rowCount = 1
        }
    }
}

class FamilyCellDataSource{
    var cellType: AcademicFamilyCellType!
    var attachedObj:Any?
    var attachedDs:Any?
    var isCumpulsory:Bool
    
    init(type:AcademicFamilyCellType, obj:Any?, dataSource:Any?, compulsoryFlag:Bool) {
        self.cellType = type
        self.attachedObj = obj
        self.attachedDs = dataSource
        self.isCumpulsory = compulsoryFlag
    }
}

extension FamilyCellDataSource{
    func setValues(value:String, otherObj:Any?, indexPath:IndexPath){
        let sectionType = AdmissionFamilyManager.shared.dataSource[indexPath.section]
        
        if sectionType.headerType == .father{
            let fatherDs = sectionType.attachedObj
            let rowCell = fatherDs[indexPath.row]
            
            switch rowCell.cellType {
            case .fullName:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherFullName = value
                
            case .DOB:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherDob = value
                if let number = otherObj as? Int{
                    AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherAge = "\(number)"
                }
                
            case .age:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherAge = value
                
                
            case .contactNumber:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherContactNumber = value
                
                
            case .emailAddress:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherEmail = value
                
                
            case .profession:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherProfession = value
                
            case .industry:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherIndustry = value
                
                
            case .totalIncome:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherTotalIncome = value
                
            case .countryOfWork:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherCounty = value
                
            default: break
                
            }
            
        }else if sectionType.headerType == .mother{
            let motherDs = sectionType.attachedObj
            let rowCell = motherDs[indexPath.row]
            
            switch rowCell.cellType {
            case .fullName:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherFullName = value
                
            case .DOB:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherDob = value
                if let number = otherObj as? Int{
                    AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherAge = "\(number)"
                }
                
            case .age:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherAge = value
                
                
            case .contactNumber:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherContactNumber = value
                
                
            case .emailAddress:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherEmail = value
                
                
            case .profession:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherProfession = value
                
            case .industry:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherIndustry = value
                
                
            case .totalIncome:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherTotalIncome = value
                
            case .countryOfWork:
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherCountry = value
                
            default: break
                
            }
            
        }

        
    }

}
