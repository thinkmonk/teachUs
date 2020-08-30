//
//  DeleteAttendanceLogDataSource.swift
//  TeachUs
//
//  Created by iOS on 30/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
enum DeleteAttendanceLogCellType {
    case UserType
    case UserName
    case RequestType
    case RequestClass
    case RequestSubject
    case Reason
    case logHeader
    case LogDetails
    case SyllabusDetail
    case ApproveOrRejectButton
    
    var keyName:String{
        switch self {
        case .UserType: return "Type"
        case .UserName:return "Faculty Name"
        case .RequestType: return "Request"
        case .RequestClass: return "Class"
        case .RequestSubject: return "Subject"
        case .Reason: return "Reason"
        case .logHeader: return "Logs"
        default: return ""
        }
    }
}

class DeleteAttendanceLogDataSource: NSObject {
    var logsCellType : DeleteAttendanceLogCellType?
    var attachedObject : Any?
    
    init(celType: DeleteAttendanceLogCellType, attachedObject: Any?) {
        self.logsCellType = celType
        self.attachedObject = attachedObject
    }
    
}
