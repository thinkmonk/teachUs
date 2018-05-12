//
//  LectureReport.swift
//  TeachUs
//
//  Created by ios on 5/11/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 "lecture_report": {
         "course_name": "FYBMS - A",
         "lecture_date": "2018-02-25",
         "no_of_lecture": "2",
         "from_time": "03:00 AM",
         "to_time": "04:00 AM",
         "modified_on": "12:00 AM",
         "subject_code": "OR",
         "subject_name": "Operations Research",
         "unit_list": [
         {
         "unit_id": "1",
         "unit_name": "Unit 01",
         "topic_list": [
         {
         "topic_id": "1",
         "topic_name": "LPP Graphical",
         "status": "1"
         }
         ]
         },
         "total_student_attendance": "15"
 }
 
 */

class LectureReport:Mappable{
    var courseName:String = ""
    var lectureDate:String = ""
    var numberOfLecture:String = ""
    var fromTime:String = ""
    var toTime:String = ""
    var modifiedOn:String = ""
    var subjectCode:String = ""
    var subjectName:String = ""
    var totalAttendanceCount:String = ""
    var unitDetails:[Unit] = []
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        self.courseName <- map["course_name"]
        self.lectureDate <- map["lecture_date"]
        self.numberOfLecture <- map["no_of_lecture"]
        self.fromTime <- map["from_time"]
        self.toTime <- map["to_time"]
        self.modifiedOn <- map["modified_on"]
        self.subjectCode <- map["subject_code"]
        self.subjectName <- map["subject_name"]
        self.totalAttendanceCount <- map["total_student_attendance"]
        self.unitDetails <- map["unit_list"]
    }
    
    
}
