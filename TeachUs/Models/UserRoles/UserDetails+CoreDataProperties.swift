//
//  UserDetails+CoreDataProperties.swift
//  TeachUs
//
//  Created by ios on 3/11/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var contact: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var login_id: String?
    @NSManaged public var profilePicUrl: String?
    @NSManaged public var college: NSSet?

}

// MARK: Generated accessors for college
extension UserDetails {

    @objc(addCollegeObject:)
    @NSManaged public func addToCollege(_ value: CollegeDetails)

    @objc(removeCollegeObject:)
    @NSManaged public func removeFromCollege(_ value: CollegeDetails)

    @objc(addCollege:)
    @NSManaged public func addToCollege(_ values: NSSet)

    @objc(removeCollege:)
    @NSManaged public func removeFromCollege(_ values: NSSet)

}
