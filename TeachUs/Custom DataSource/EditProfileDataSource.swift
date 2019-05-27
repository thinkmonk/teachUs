//
//  EditProfileDataSource.swift
//  TeachUs
//
//  Created by ios on 5/11/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
enum EditProfileCellType{
    case cellTypeId
    case cellTypeName
    case cellTypeEmail
    case cellTypeMobileNumber
    case cellTypecollegeName
    case cellTypeCourseName
    case cellTypeYear
    case cellTypeSemester
    case cellTypeSubjectTitle
    case cellTypeSubjectList
    case cellTypeDivision
    case cellTypeSubjectName
    case cellTypeProfessorCollegeName
    case cellTypeProfessorRole
}

class EditProfileDataSource{
    var cellType:EditProfileCellType!
    var attachedObject:Any?
    
    init(profileCell:EditProfileCellType, profileObject:Any?) {
        self.cellType = profileCell
        self.attachedObject = profileObject
    }

}
