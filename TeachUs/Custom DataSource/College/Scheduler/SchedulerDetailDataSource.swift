//
//  SchedulerDetailDataSource.swift
//  TeachUs
//
//  Created by iOS on 12/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
enum ScheduleDetailCellType {
    case AddSchedule
    case ScheduleDate
    case SchdeuleDetails
}


class ScheduleDetailDataSource{
    var cellType:ScheduleDetailCellType!
    var attachedObject:Any?
    
    init(detailsCell:ScheduleDetailCellType, detailsObject:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
    }
}
