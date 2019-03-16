//
//  CollegeClassManager.swift
//  TeachUs
//
//  Created by ios on 3/4/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
import RxSwift

class SelectCollegeClass{
    var collegeClass : CollegeAttendanceList?
    var isSelected:Bool!
    
    init(_ classDetails:CollegeAttendanceList, _ isClassSelected:Bool) {
        self.collegeClass = classDetails
        self.isSelected = isClassSelected
    }
}


class SelectCollegeCourse{
    var collegeCourse : CourseList?
    var isSelected:Bool!
    
    init(_ courseDetails:CourseList, _ isCourseSelected:Bool) {
        self.collegeCourse = courseDetails
        self.isSelected = isCourseSelected
    }
}



class CollegeClassManager{
    
    static var sharedManager = CollegeClassManager()
    var selectedClassArray : [SelectCollegeClass] = []
    var selectedAttendanceCriteria:Int!
    var email = Variable<String>("")
    var getSelectedClassList:String {
        let selectedClassArray:[SelectCollegeClass] = self.selectedClassArray.filter({$0.isSelected == true})
        let selectedClassIdArray: [String] = selectedClassArray.map({$0.collegeClass?.classId ?? ""})
        return selectedClassIdArray.joined(separator: ",")
    }
    
    var selectedCourseArray : [SelectCollegeCourse] = []
    var getSelectedCourseList:String {
        let selectedCourseArray:[SelectCollegeCourse] = self.selectedCourseArray.filter({$0.isSelected == true})
        let selectedCourseIdArray: [String] = selectedCourseArray.map({$0.collegeCourse?.courseID ?? ""})
        return selectedCourseIdArray.joined(separator: ",")
    }
}
