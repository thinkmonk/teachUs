//
//  StudentDetailsDataSource.swift
//  TeachUs
//
//  Created by ios on 3/23/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation

enum StudentDetailsCellType {
    case DetailsHeader
    case AttendanceTitle
    case AttendanceDetails
    case AttendanceFooter
}


class StudentAttendanceDetailsDataSource{
    var cellType:StudentDetailsCellType!
    var attachedObject:Any?
    
    init(detailsCell:StudentDetailsCellType, detailsObject:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
    }
}
