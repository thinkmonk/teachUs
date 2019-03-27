//
//  EditAttendanceLectureInfo.swift
//  TeachUs
//
//  Created by ios on 3/27/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 "lecture_info": {
 "id": "316",
 "professor_id": "6",
 "class_id": "18",
 "subject_id": "2",
 "topics_covered": "1",
 "course_id": "3",
 "no_of_lecture": "1",
 "lecture_date": "2018-12-01",
 "from_time": "13:50",
 "to_time": "14:50",
 "modified_on": "2018-12-01 13:50:15",
 "created_on": "2018-12-01 13:50:15",
 "professor_name": "Datta Pillappa Hingmire",
 "class_division": "A",
 "year_name": "FY",
 "course": "BA",
 "subject_name": "FOUNDATION COURSE- I"
 },
 
 */

class EditAttendanceLectureInfo:Mappable{
    
    var attendanceId:String!
    var professorId:String!
    var classId:String!
    var subjectId:String!
    var topicsCoverd:String!
    var courseId:String!
    var numberOfLectures:String!
    var lectureDate:String!
    var fromTime:String!
    var toTime:String!
    var modifiedOn:String!
    var createdOn:String!
    var professorName:String!
    var classDivision:String!
    var yearName:String!
    var course:String!
    var subjectName:String!
    
    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        self.attendanceId <- map["id"]
        self.professorId <- map["professor_id"]
        self.classId <- map["class_id"]
        self.subjectId <- map["subject_id"]
        self.topicsCoverd <- map["topics_covered"]
        self.courseId <- map["course_id"]
        self.numberOfLectures <- map["no_of_lecture"]
        self.lectureDate <- map["lecture_date"]
        self.fromTime <- map["from_time"]
        self.toTime <- map["to_time"]
        self.modifiedOn <- map["modified_on"]
        self.createdOn <- map["created_on"]
        self.professorName <- map["professor_name"]
        self.classDivision <- map["class_division"]
        self.yearName <- map["year_name"]
        self.course <- map["course"]
        self.subjectName <- map["subject_name"]
        
    }
}
