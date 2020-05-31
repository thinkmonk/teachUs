//
//  AdmissionSubject.swift
//  TeachUs
//
//  Created by iOS on 31/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
enum SubjectCellType:Equatable {
    case programHeader
    case steam
    case level
    case course
    case academicYear
    case subjectHeader
    case subjectDetails(String)
    
    var value:String{
        switch self {
        case .programHeader     : return "Program/Subject"
        case .steam             : return "Select Stream"
        case .level             : return "Level"
        case .course            : return "Course"
        case .academicYear      : return "Academic Year"
        case .subjectHeader           :return "Subject"
        case .subjectDetails(let value)    :return value
        }
    }
}


enum SubjectFormSections{
    case Program
    case Subjects
}

class AdmissionSubjectSectionDataSource{
    var sectionType:SubjectFormSections
    var attachedObj:[AdmissionSubjectDataSource]
    var rowCount:Int!
    
    init(sectionType:SubjectFormSections, obj:[AdmissionSubjectDataSource]) {
        self.sectionType = sectionType
        self.attachedObj = obj
        rowCount = obj.count
    }
    
}
class AdmissionSubjectDataSource{
    var cellType:SubjectCellType!
    var attachedObject:Any?
    var dataSourceObject:Any?
    
    init(detailsCell:SubjectCellType, detailsObject:Any?, dataSource:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
        self.dataSourceObject = dataSource
    }
    
}
