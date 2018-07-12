//
//  OfflineUserData+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 7/12/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension OfflineUserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineUserData> {
        return NSFetchRequest<OfflineUserData>(entityName: "OfflineUserData")
    }

    @NSManaged public var data: NSObject?

}
