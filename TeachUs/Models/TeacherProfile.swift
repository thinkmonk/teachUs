//
//  TeacherProfile.swift
//  TeachUs
//
//  Created by ios on 11/28/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 {
 "profiles": {
 "profile": [
 {
 "role": "PROFESSOR",
 "professorId": 3,
 "professorName": "Harsh",
 "professorLastName": "Gangar",
 "collegeId": "1003",
 "collegeName": "Rajasthani Sammelans Ghanshyamdas Saraf Colle",
 "attendenceUrl": "/teacher/getCollegeSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
 "syllabusStatusUrl": "/teacher/getSyllabusSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
 "logsUrl": "/teacher/getLogsSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
 "uploadProfilePicUrl": "/teacher/uploadImage/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
 "uploadProfilePicBase64Url": "/teacher/uploadImageBase64/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3"
 }
 ]
 },
 "image": "/teacher/getImage/"
 }
 */

class TeacherProfile:Mappable{
    var attendenceUrl = ""
    var syllabusStatusUrl = ""
    var logsUrl = ""
    var uploadProfilePicUrl = ""
    var uploadProfilePicBase64Url = ""
    var userRole = ""
    var professorId:Int = 0
    var professorName = ""
    var professorLastName = ""
    var collegeId = ""
    var collegeName = ""
    var userImage = ""
    
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.attendenceUrl <- map["attendenceUrl"]
        self.syllabusStatusUrl <- map["syllabusStatusUrl"]
        self.logsUrl <- map["logsUrl"]
        self.uploadProfilePicUrl <- map["uploadProfilePicUrl"]
        self.uploadProfilePicBase64Url <- map["uploadProfilePicBase64Url"]
        self.userRole <- map["role"]
        self.professorId <- map["professorId"]
        UserManager.sharedUserManager.setUserId("\(self.professorId)")
        self.professorName <- map["professorName"]
        self.professorLastName <- map["professorLastName"]
        self.collegeId <- map["attendenceUrl"]
        self.collegeName <- map["collegeName"]
    }
}
