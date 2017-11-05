//
//  CollegeSummary.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

public class College:Mappable{
    
    var name:String?
    var college_id:String?
    var collegeSubjects  = [CollegeSubjects]()
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.name <- map["collegeName"]
        self.college_id <- map["collegeId"]
        var tempSubjects:[[String:Any]] = []
        tempSubjects <- map["subjects"]
        if(tempSubjects.count > 0){
            
            for subject in tempSubjects {
            let collegeSubject:CollegeSubjects = Mapper<CollegeSubjects>().map(JSONObject: subject)!
            self.collegeSubjects.append(collegeSubject)
            }
        }
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


public class CollegeSubjects:Mappable{
    
    var classId:Int?
    var year:String?
    var semester:String?
    var courseCode:String?
    var subjectId:Int?
    var subjectName:String?
    var section:String?
    var enrolledStudentListUrl:String?
    
    required public init?(map: Map) {
    }
    
    
    public func mapping(map: Map) {
        self.subjectName <- map["subjectName"]
        self.classId <- map["classId"]
        self.semester <- map["semester"]
        self.year <- map["year"]
        self.courseCode <- map["courseCode"]
        self.subjectId <- map["subjectId"]
        self.section <- map["secion"]
        self.enrolledStudentListUrl <- map["enrolledStudentListUrl"]
    }

    
}
