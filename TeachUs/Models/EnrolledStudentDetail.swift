//
//  EnrolledStudentDetail.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

public class EnrolledStudentDetail :Mappable{
    var studentId:Int?
    var studentRollNo:Int?
    var lectureAttended:Int?
    var totalLecture:Int?
    var percentage:Int?
    var subjectId:Int?
    var studentName:String?
    var studentLastName:String?
    var subject:String?
    var imageUrl:String?
    var lastLecture:String?
    
    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        self.studentId <- map["studentId"]
        self.studentRollNo <- map["studentRollNo"]
        self.lectureAttended <- map["lectureAttended"]
        self.percentage <- map["percentage"]
        self.totalLecture <- map["totalLecture"]
        self.subjectId <- map["subjectId"]
        self.studentName <- map["studentName"]
        self.studentLastName <- map["studentLastName"]
        self.subject <- map["subject"]
        var photoUrl :String = ""
        photoUrl <- map["image"]
        self.imageUrl = URLConstants.BaseUrl.baseURL + photoUrl
        self.lastLecture <- map["lastLecture"]
    }


}


/*
 "studentDetail": [
 {
 "studentId": 1,
 "studentRollNo": 1,
 "studentName": "Dnyaneshwar",
 "studentLastName": "Muley",
 "lastLecture": "ABSENT",
 "lectureAttended": 19,
 "totalLecture": 26,
 "percentage": 73,
 "subjectId": 0,
 "subject": "ETHICS",
 "image": "/student/getImage/1_Dnyaneshwar_Muley_.jpg"
 },

 */
