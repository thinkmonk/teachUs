//
//  OfflineApiRequest+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 7/25/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension OfflineApiRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineApiRequest> {
        return NSFetchRequest<OfflineApiRequest>(entityName: "OfflineApiRequest")
    }

    @NSManaged public var attendanceParams: NSObject?
    @NSManaged public var syllabusParams: NSObject?

}
