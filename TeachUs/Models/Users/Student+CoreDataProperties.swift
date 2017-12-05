//
//  Student+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 12/4/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var attendanceUrl: String?
    @NSManaged public var collegeId: String?
    @NSManaged public var collegeName: String?
    @NSManaged public var ratingsUrl: String?
    @NSManaged public var role: String?
    @NSManaged public var sllyabusStatusUrl: String?
    @NSManaged public var studentId: Int16
    @NSManaged public var studentLastName: String?
    @NSManaged public var studentName: String?
    @NSManaged public var uploadProfilePicUrl: String?
    @NSManaged public var isCurrentUser: Bool

}
