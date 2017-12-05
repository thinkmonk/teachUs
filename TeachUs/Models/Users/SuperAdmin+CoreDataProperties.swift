//
//  SuperAdmin+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 12/4/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension SuperAdmin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SuperAdmin> {
        return NSFetchRequest<SuperAdmin>(entityName: "SuperAdmin")
    }

    @NSManaged public var adminListUrl: String?
    @NSManaged public var classAttendanceUrl: String?
    @NSManaged public var classSyllabusUrl: String?
    @NSManaged public var collegeId: String?
    @NSManaged public var collegeName: String?
    @NSManaged public var courseRatingsUrl: String?
    @NSManaged public var eventAttendanceUrl: String?
    @NSManaged public var role: String?
    @NSManaged public var isCurrentUser: Bool

}
