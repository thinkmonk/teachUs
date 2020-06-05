//
//  AdmissionAcademicDataSource.swift
//  TeachUs
//
//  Created by iOS on 01/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

enum AcademicCellType:String{
    case academincRecordHeader      =  "Previous Academic Record"
    case degreeName                 =  "Name Of Degree"
    case mediumOfInstruction        = "Medium Of Instruction "
    case degreeDuration             = "Duration of Degree"
    case SchemeOfExamination        = "Scheme of examination"
    case discipline                 = "Discipline"
    case prnNuber                   = "University enrollment number/PRN number"
    case unversityName              = "University Name"
    case inHouse                    = "In-house"
    case InstituteName              = "Institute Name"
    case markingSystem              = "Marking System"
    case recordHeader               = "Record"
    case recordNumberHeader         = ""
    case academicYear               = "Academic Year"
    case semester                   = "Semester"
    case resultDeclared             = "Result Declared"
    case cgpa                       = "SCGPA/CGPA"
    case creditEarned               = "Credit Earned"
    case grade                      = "Grade"
    case passingMonth               = "Passing Month"
    case passingYear                = "Passing Year"
    case atkt                       = "Number of backlog/ATKT"
    case addNewRecord               = "newRecord"
}


enum RecordSections{
    case previousRecords
    case recordsData
    case addNewRecord
}


class AcademicSectionDataSource{
    var headerType: RecordSections!
    var attachedObj  = [AcademicRowDataSource]()
    var rowCount:Int!
    
    init(type:RecordSections, attachedObj:[AcademicRowDataSource]) {
        self.headerType = type
        self.attachedObj = attachedObj
        rowCount = attachedObj.count
    }
}

class AcademicRowDataSource{
    var cellType: AcademicCellType!
    var attachedObj:Any?
    var attachedDs:Any?
    var isCumpulsory:Bool
    var isgreyedOUt:Bool
    
    init(type:AcademicCellType, obj:Any?, dataSource:Any?, compulsoryFlag:Bool, greyedOut:Bool) {
        self.cellType = type
        self.attachedObj = obj
        self.attachedDs = dataSource
        self.isCumpulsory = compulsoryFlag
        self.isgreyedOUt = greyedOut
    }
}

extension AcademicRowDataSource{
    func setValues(value:String, otherObj:Any?, indexPath:IndexPath){
        if var academicInfo = AdmissionResultManager.shared.recordData
        {
            if self.cellType == .inHouse{
                AdmissionResultManager.shared.recordData?.academicRecord?.inHouse = value
        
            }else if self.cellType == .prnNuber{
                AdmissionResultManager.shared.recordData?.academicRecord?.prnNo = value
            }else if AdmissionResultManager.shared.dataSource[indexPath.section].headerType == .recordsData, var recordInfo = academicInfo.academicRecord?.result?[indexPath.section-1]{
                //-1 as first indexpath is previous record section
                switch self.cellType! {
                case .academicYear:
                    recordInfo.academicYear = value
                case .semester:
                    recordInfo.academicSemester = value
                case .resultDeclared:
                    recordInfo.resultStatus = value
                case .cgpa:
                    recordInfo.marks = value
                case .creditEarned:
                    recordInfo.creditEarned = value
                case .grade:
                    recordInfo.grade = value
                case .passingMonth:
                    recordInfo.passingMonth = value
                case .atkt:
                    recordInfo.passingMonth = value
                    
                default:break
                }
                AdmissionResultManager.shared.recordData?.academicRecord?.result?[indexPath.section-1] = recordInfo
            }
        }
        
    }

}
