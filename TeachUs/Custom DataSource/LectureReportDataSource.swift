//
//  LectureReportDataSource.swift
//  TeachUs
//
//  Created by ios on 5/11/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
enum LectureReportCellType{
    case ClassName
    case LectureTIme
    case NumberOfLecture
    case TotalAttendance
    case TimeOfSubmission
    case SubjectDetails
}

class  LectureReportDataSource{
    var reportCellType:LectureReportCellType!
    var attachedObject:Any!
    
    init(cellType:LectureReportCellType , object:Any?) {
        self.reportCellType = cellType
        self.attachedObject = object
    }
}
