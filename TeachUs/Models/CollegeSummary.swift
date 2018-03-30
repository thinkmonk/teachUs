//
//  CollegeSummary.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper


/*
 
 {
 "class_division" = A;
 "class_id" = 1;
 "course_code" = BMS;
 "course_id" = 1;
 semester = 1;
 "subject_code" = RM;
 "subject_id" = 6;
 "subject_name" = "Risk Management";
 year = 1;
 "year_name" = FY;
 }
 */

public class College:Mappable{
    
    var name:String?
    var classDivision:String?
    var classId:String?
    var courseCode:String?
    var courseId:String?
    var semester:String?
    var subjectCode:String?
    var subjectId:String?
    var subjectName:String?
    var year:String?
    var yearName:String?
//    var college_id:String?
//    var collegeSubjects  = [CollegeSubjects]()

    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.name  = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_name!)"
        self.classDivision <- map["class_division"]
        self.classId <- map["class_id"]
        self.courseCode <- map["course_code"]
        self.courseId <- map["course_id"]
        self.semester <- map["semester"]
        self.subjectCode <- map["subject_code"]
        self.subjectId <- map["subject_id"]
        self.subjectName <- map["subject_name"]
        self.year <- map["year"]
        self.yearName <- map["year_name"]
    }
    
}

/*
 
 "college": [
 {
 "collegeId": "1001",
 "collegeName": "ATHARVA COLLEGE",
 "subjects": [
 {
 "classId": 1,
 "year": "4",
 "semester": "1",
 "secion": "A",
 "courseCode": "BECS",
 "subjectId": 2,
 "subjectName": "ECONOMICS",
 "enrolledStudentListUrl": "/teacher/getEnrolledStudentList/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=2"
 },
 */

