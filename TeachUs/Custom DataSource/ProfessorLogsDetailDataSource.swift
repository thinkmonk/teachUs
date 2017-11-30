//
//  ProfessorLogsDetailDataSource.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
enum ProfessorLogsDetailCellType {
    case LogDetails
    case SyllabusDetail
}

class ProfessorLogsDataSource: NSObject {
    var logsCellType : ProfessorLogsDetailCellType?
    var attachedObject : Any?
    var attachedView : Any?
    var isSelected : Bool?
    
    init(celType: ProfessorLogsDetailCellType, attachedObject: Any?) {
        
        self.logsCellType = celType
        self.attachedObject = attachedObject
    }
    
}
