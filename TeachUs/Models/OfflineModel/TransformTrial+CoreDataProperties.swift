//
//  TransformTrial+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 7/8/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension TransformTrial {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransformTrial> {
        return NSFetchRequest<TransformTrial>(entityName: "TransformTrial")
    }

    @NSManaged public var data: NSObject?

}
