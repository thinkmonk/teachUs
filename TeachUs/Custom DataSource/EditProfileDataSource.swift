//
//  EditProfileDataSource.swift
//  TeachUs
//
//  Created by ios on 5/11/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
enum EditProfileCellType{
    case id
    case name
    case email
    case number
    case collegeName
    case courseName
    case typeYear
    case semester
    case subjectTitle
    case subjectList
    case division
    case subjectName
    case professorCollegeName
    case professorRole
    case studentName
    case studetnCollegeName
    case studentClass
    case studentDivision
    case rollNumber
}

class EditProfileDataSource{
    var cellType:EditProfileCellType!
    var attachedObject:Any?
    
    init(profileCell:EditProfileCellType, profileObject:Any?) {
        self.cellType = profileCell
        self.attachedObject = profileObject
    }

}
