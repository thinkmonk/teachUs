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
//    case industry               = "Industry"
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
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherFullName = value
                
            case .DOB://seperately calculated added. hence not using rowCell.attachedObj = value
                if let number = otherObj as? Int{
                    AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherAge = "\(number)"
                }else{
                    AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherDob = value
                }
                
            case .age://seperately calculated added. hence not using rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherAge = value
                
                
            case .contactNumber:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherContactNumber = value
                
                
            case .emailAddress:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherEmail = value
                
                
            case .profession:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherProfession = value
                
//            case .industry:
//                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherIndustry = value
                
                
            case .totalIncome:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherTotalIncome = value
                
            case .countryOfWork:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.fatherCounty = value
                
            default: break
                
            }
            
        }else if sectionType.headerType == .mother{
            let motherDs = sectionType.attachedObj
            let rowCell = motherDs[indexPath.row]
            
            switch rowCell.cellType {
            case .fullName:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherFullName = value
                
            case .DOB://seperately calculated added. hence not using rowCell.attachedObj = value
                if let number = otherObj as? Int{
                    AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherAge = "\(number)"
                }else{
                    rowCell.attachedObj = value
                    AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherDob = value

                }
                
            case .age://seperately calculated added. hence not using rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherAge = value
                
                
            case .contactNumber:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherContactNumber = value
                
                
            case .emailAddress:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherEmail = value
                
                
            case .profession:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherProfession = value
                
//            case .industry:
//                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherIndustry = value
//                
                
            case .totalIncome:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherTotalIncome = value
                
            case .countryOfWork:
                rowCell.attachedObj = value
                AdmissionFamilyManager.shared.familyData.familyDetailsInformation?.motherCountry = value
                
            default: break
                
            }
            
        }

        
    }

}
