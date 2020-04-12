//
//  CollegeClassManager.swift
//  TeachUs
//
//  Created by ios on 3/4/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

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
    var courseListData : CourseDetails?
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
    
    //FOR ADMIN
    var selectedAdminClassArray : [SelectCollegeClass] = []
    var getSelectedAminClassList:String {
        let selectedAdminClassArray:[SelectCollegeClass] = self.selectedAdminClassArray.filter({$0.isSelected == true})
        let selectedClassIdArray: [String] = selectedAdminClassArray.map({$0.collegeClass?.classId ?? ""})
        return selectedClassIdArray.joined(separator: ",")
    }
    
    final func getCourseList(completion: ((Bool) -> Void)? = nil) {
        let manager = NetworkHandler()
        manager.url = URLConstants.SyllabusURL.getCourseList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: " Get all Course List college class manager", parameters:parameters, completionHandler: {[weak self] (result, code, response) in
            self?.courseListData?.courseList.removeAll()
            do{
                let decoder = JSONDecoder()
                self?.courseListData = try decoder.decode(CourseDetails.self, from: response)
                completion?(true)
            }
            catch let error{
                print("err", error)
                completion?(false)
            }
        }) { (error, code, message) in
            completion?(false)
        }
        
    }
    
    final func getAllClass(completion: ((Bool) -> Void)? = nil){
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegAdminClassList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        manager.apiPost(apiName: " Get all Class List", parameters:parameters, completionHandler: { (result, code, response) in
            guard let attendanceListArray = response["class_list"] as? [[String:Any]] else{
                return
            }
            self.selectedAdminClassArray.removeAll()
            for attendancelist in attendanceListArray{
                guard let tempList = Mapper<CollegeAttendanceList>().map(JSONObject: attendancelist) else{
                    return
                }
                let classObj = SelectCollegeClass(tempList, true)
                self.selectedAdminClassArray.append(classObj)
                completion?(true)
            }
        }) { (error, code, message) in
            completion?(false)
        }

    }
}
