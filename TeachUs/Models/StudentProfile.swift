//
//  StudentProfile.swift
//  TeachUs
//
//  Created by ios on 12/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper


/*
 {
 "profiles": {
 "profile": [
 {
 "role": "STUDENT",
 "studentId": 4,
 "studentName": "Harsh",
 "studentLastName": "Gangar",
 "collegeId": "1001",
 "collegeName": "ATHARVA COLLEGE",
 "attendenceUrl": "/student/getAttendence/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4",
 "syllabusStatusUrl": "/student/getSyllabusSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4",
 "ratingsUrl": "/student/getRatingsSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4",
 "uploadProfilePicUrl": "/student/uploadImageBase64/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4"
 }
 ]
 }
 }

 */
 
 class StudentProfile:Mappable{
    var userRole = ""
    var studentId:Int = 0
    var studentName:String = ""
    var studentLastName:String = ""
    var collegeId:String = ""
    var collegeName:String = ""
    var attendanceURL:String = ""
    var syllabusStatusURL:String = ""
    var ratingsURL:String = ""
    var uploadProfilePicUrl:String = ""
    var userImage:String = ""
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.userRole <- map["role"]
        self.studentId <- map["studentId"]
        UserManager.sharedUserManager.setUserId("\(self.studentId)")

        self.studentName <- map["studentName"]
        self.studentLastName <- map["studentLastName"]
        self.collegeId <- map["collegeId"]
        self.collegeName <- map["collegeName"]
        self.attendanceURL <- map["attendenceUrl"]
        self.syllabusStatusURL <- map["syllabusStatusUrl"]
        self.ratingsURL <- map["ratingsUrl"]
        self.uploadProfilePicUrl <- map["uploadProfilePicUrl"]
        self.userImage <- map[""]
    }
}
