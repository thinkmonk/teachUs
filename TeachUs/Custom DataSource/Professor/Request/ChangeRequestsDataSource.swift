//
//  ChangeRequestsDataSource.swift
//  TeachUs
//
//  Created by iOS on 30/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

enum ChangeRequestCellType {
    case deleteAttendance
    case nameChange
}

class ChangeRequestsDataSource: NSObject {
    
    var cellType : ChangeRequestCellType?
    var attachedObject : Any?
    
    init(celType: ChangeRequestCellType, attachedObject: Any?) {
        self.cellType = celType
        self.attachedObject = attachedObject
    }
}
