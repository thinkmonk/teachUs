//
//  CollegeSubjects.swift
//  TeachUs
//
//  Created by ios on 3/31/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//


/*
 "subject_list": [
 {
 "class_id": "1",
 "class_division": "A",
 "year": "1",
 "year_name": "FY",
 "specialisation": "Finance",
 "course_id": "1",
 "semester": "1",
 "subject_id": "3",
 "subject_name": "Operations Research",
 "subject_code": "OR"
 },


*/

import Foundation
import ObjectMapper

public class CollegeSubjects:Mappable{
    
    var classId:String?
    var classDivivsion:String?
    var year:String?
    var yearName:String?
    var specialisation:String?
    var courseId:String?
    var semester:String?
    var subjectId:String?
    var subjectName:String?
    var subjectCode:String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.classId <- map["class_id"]
        self.classDivivsion <- map["class_division"]
        self.year <- map["year"]
        self.yearName <- map["year_name"]
        self.specialisation <- map["specialisation"]
        self.courseId <- map["course_id"]
        self.semester <- map["semester"]
        self.subjectId <- map["subject_id"]
        self.subjectName <- map["subject_name"]
        self.subjectCode <- map["subject_code"]
        
    }
}
