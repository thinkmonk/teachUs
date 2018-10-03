//
//  CollegeAttendanceList.swift
//  TeachUs
//
//  Created by ios on 3/18/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 {
 "year_name": "FY",
 "class_division": "A",
 "class_id": "1",
 "semester": "1",
 "course_code": "BMS",
 "course_name": "FYBMS",
 "total_students": "18",
 "avg_students": "13"
 }
 
 */



class CollegeAttendanceList:Mappable{
    var yearName:String = ""
    var classDivision:String = ""
    var classId:String = ""
    var semester:String = ""
    var courseCode:String = ""
    var courseName:String = ""
    var totalStudents:String = ""
    var avgStudents:String = ""
    var year:String = ""
    
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.yearName <- map["year_name"]
        self.classDivision <- map["class_division"]
        self.classId <- map["class_id"]
        self.semester <- map["semester"]
        self.courseCode <- map["course_code"]
        self.courseName <- map["course_name"]
        self.totalStudents <- map["total_students"]
        self.avgStudents <- map["avg_students"]
        self.year <- map["year"]
    }

}
