//
//  CollegeClassManager.swift
//  TeachUs
//
//  Created by ios on 3/4/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
class SelectCollegeClass{
    var collegeClass : CollegeAttendanceList?
    var isSelected:Bool!
    
    init(_ classDetails:CollegeAttendanceList, _ isClassSelected:Bool) {
        self.collegeClass = classDetails
        self.isSelected = isClassSelected
    }
}

class CollegeClassManager{
    
    static var sharedManager = CollegeClassManager()
    var selectedClassArray : [SelectCollegeClass] = []
    
    var getSelectedClassList:String {
        let selectedClassArray:[SelectCollegeClass] = self.selectedClassArray.filter({$0.isSelected == true})
        let selectedClassIdArray: [String] = selectedClassArray.map({$0.collegeClass?.classId ?? ""})
        return selectedClassIdArray.joined(separator: ",")
    }
}
