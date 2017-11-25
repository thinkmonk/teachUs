//
//  RatingDataSource.swift
//  TeachUs
//
//  Created by ios on 11/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation

enum RatingCellType {
    case TeacherProfile
    case RatingTitle
    case RatingTopics
}

class RatingDataSource: NSObject {
    var ratingCellType : RatingCellType?
    var attachedObject : Any?
    var attachedView : Any?
    var isSelected : Bool?
    
    init(celType: RatingCellType, attachedObject: Any?) {
        
        self.ratingCellType = celType
        self.attachedObject = attachedObject
    }

}
