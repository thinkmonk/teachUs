//
//  AttendanceDataSource.swift
//  TeachUs
//
//  Created by ios on 11/11/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation


enum AttendanceCellType {
    case calender
    case defaultSelection
    case attendanceCount
    case studentProfile
}

class AttendanceDatasource: NSObject {
    
    var AttendanceCellType : AttendanceCellType?
    var attachedObject : Any?
    var attachedView : Any?
    var isSelected : Bool?
    
    init(celType: AttendanceCellType, attachedObject: Any?) {
        
        self.AttendanceCellType = celType
        self.attachedObject = attachedObject
    }
}
