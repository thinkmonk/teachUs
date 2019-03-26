//
//  LogDetails.swift
//  TeachUs
//
//  Created by ios on 5/6/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 "subject_logs": [
 {
 "att_id" = 378; <- Added in v2
 "course_name": "FYBMS - A",
 "lecture_date": "2018-02-25",
 "no_of_lecture": "2",
 "from_time": "03:00:00",
 "to_time": "04:00:00",
 "date_of_submission": "0000-00-00 00:00:00",
 "unit_list": [
 {
 "unit_id": "1",
 "unit_name": "Unit 01",
 "topic_list": [
 {
 "topic_id": "5",
 "topic_name": "Transportation",
 "status": "2"
 },
 {
 "topic_id": "6",
 "topic_name": "Assignment",
 "status": "1"
 }
 ]
 }
 ],
 "total_student_attendance": "15"
 },
 
 */

class LogDetails:Mappable{
    var courseName:String = " "
    var lectureDate:String = " "
    var numberOfLecture:String = " "
    var fromTime:String = " "
    var toTime:String = " "
    var dateOfSubmission:String = " "
    var totalStudentAttendance:String = " "
    var unitArray:[Unit] = []
    var attendanceId:String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.courseName <- map["course_name"]
        self.lectureDate <- map["lecture_date"]
        self.numberOfLecture <- map["no_of_lecture"]
        self.fromTime <- map["from_time"]
        self.toTime <- map["to_time"]
        self.dateOfSubmission <- map["date_of_submission"]
        self.totalStudentAttendance <- map["total_student_attendance"]
        self.unitArray  <- map["unit_list"]
        self.attendanceId <- map["att_id"]
    }
    
}
