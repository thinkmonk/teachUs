//
//  MarkSyllabusDataSource.swift
//  TeachUs
//
//  Created by iOS on 12/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
enum SyllabusCellType {
    case Unit
    case Other
}

class MarkSyllabusDataSource: NSObject {
    
    var syallbusCellType : SyllabusCellType?
    var attachedObject : Any?
    var rowCount:Int = 0
    
    init(cellType: SyllabusCellType, attachedObject: Any?) {
        
        self.syallbusCellType = cellType
        self.attachedObject = attachedObject
        if let unitObj = attachedObject as? UnitSyllabusArray, syallbusCellType == .Unit{
            rowCount = unitObj.topicList.count
        }else if let unitObj = attachedObject as? Offline_Unit_syllabus_array , syallbusCellType == .Unit{
            rowCount = unitObj.topic_list?.count ?? 0
        }
    }
}
