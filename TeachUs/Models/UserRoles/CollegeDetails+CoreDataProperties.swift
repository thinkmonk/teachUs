//
//  CollegeDetails+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 3/18/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension CollegeDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollegeDetails> {
        return NSFetchRequest<CollegeDetails>(entityName: "CollegeDetails")
    }

    @NSManaged public var college_code: String?
    @NSManaged public var college_id: String?
    @NSManaged public var college_name: String?
    @NSManaged public var privilege: String?
    @NSManaged public var role_id: String?
    @NSManaged public var role_name: String?
    @NSManaged public var isCurrentProile: Bool

}
