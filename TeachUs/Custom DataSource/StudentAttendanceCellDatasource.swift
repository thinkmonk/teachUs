//
//  StudentAttendanceCellDatasource.swift
//  TeachUs
//
//  Created by ios on 6/30/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation

enum StudentAttendanceCellType {
    case ClassAttendance
    case EventAttendance
}

class StudentAttendanceCellDatasource{
    
    var attendanceCellType:StudentAttendanceCellType!
    var attachedObject:Any
    
    init(cellType:StudentAttendanceCellType, object:Any){
        self.attendanceCellType = cellType
        self.attachedObject = object
    }
}
