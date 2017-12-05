//
//  Teacher+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 12/4/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var attendanceUrl: String?
    @NSManaged public var collegeId: String?
    @NSManaged public var collegeName: String?
    @NSManaged public var image: String?
    @NSManaged public var logsUrl: String?
    @NSManaged public var professorId: Int16
    @NSManaged public var professorLastName: String?
    @NSManaged public var professorName: String?
    @NSManaged public var role: String?
    @NSManaged public var syllabusStatusUrl: String?
    @NSManaged public var uploadProfilePicUrl: String?
    @NSManaged public var isCurrentUser: Bool

}
