//
//  EnrolledStudentDetail.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper


/*
 
 {
 "class_id": "1",
 "student_id": "4",
 "roll_number": "1001",
 "f_name": "Miren",
 "l_name": "Chetan",
 "m_name": "Shah",
 "email": "miren@gmail.com",
 "gender": "male",
 "dob": "2018-02-01",
 "contact": "9819348451",
 "profile": "http://zilliotech.com/api/profile/25aaaa61cb4b98.jpg",
 "last_present": "1",
 "lectures_attended": "4",
 "total_lectures": "5",
 "perecentage_att": "80"
 
 
 
 "class_id": "1",
 "student_id": "4",
 "roll_number": "1001",
 "f_name": "Miren",
 "l_name": "Chetan",
 "m_name": "Shah",
 "email": "miren@gmail.com",
 "gender": "male",
 "dob": "2018-02-01",
 "contact": "9819348451",
 "profile": "http://zilliotech.com/api/profile/25aaaa61cb4b98.jpg",
 "last_present": "1",
 "lectures_attended": "8",
 "total_lectures": "10",
 "perecentage_att": "80"

 }
 
 */

public class EnrolledStudentDetail :Mappable{
    var classId:String? = ""
    var studentId:String? = ""
    var studentRollNo:String? = ""
    var studentFirstName:String? = ""
    var studentMiddleName:String? = ""
    var studentLastName:String? = ""
    var studentEmail:String? = ""
    var studentGender:String? = ""
    var studentDob:String? = ""
    var studentContact:String? = ""
    var imageUrl:String? = ""
    var lastPresent:String? = ""
    var lectureAttended:String? = ""
    var totalLecture:String? = ""
    var percentage:String? = ""
    var lastLectureAttendance:String? = ""
    var studentName:String? = ""

    ///For Edit attendance flow
    var attendanceStatus:String?
    var editAttendanceStudentName:String?
    
    
    
//    var subjectId:Int?
//    var subject:String?
    
    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        self.classId <- map["class_id"]
        self.studentId <- map["student_id"]
        self.studentRollNo <- map["roll_number"]
        self.studentFirstName <- map["f_name"]
        self.studentMiddleName <- map["m_name"]
        self.studentLastName <- map["l_name"]
        self.studentEmail <- map["email"]
        self.studentGender <- map["gender"]
        self.studentDob <- map["dob"]
        self.studentContact <- map["contact"]
        self.imageUrl <- map["profile"]
        self.lastPresent <- map["last_present"]
        self.lectureAttended <- map["lectures_attended"]
        self.totalLecture <- map["total_lectures"]
        self.percentage <- map["perecentage_att"]
        self.lastLectureAttendance = (self.lastPresent == "0") ? "Absent":"Present"
        self.studentName = "\(self.studentFirstName!) \(self.studentMiddleName!) \(self.studentLastName!)"
        self.editAttendanceStudentName <- map["student_name"]
        self.studentName = self.studentName == "  " ? editAttendanceStudentName : self.studentName
        self.attendanceStatus <- map["att_status"]
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
