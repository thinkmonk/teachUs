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
    var trimmedRollNumber:String? = ""

    ///For Edit attendance flow
    var attendanceStatus:String?
    var editAttendanceStudentName:String?
    
    
    
//    var subjectId:Int?
//    var subject:String?
    
    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        classId                     <- map["class_id"]
        studentId                   <- map["student_id"]
        studentRollNo               <- map["roll_number"]
        studentFirstName            <- map["f_name"]
        studentMiddleName           <- map["m_name"]
        studentLastName             <- map["l_name"]
        studentEmail                <- map["email"]
        studentGender               <- map["gender"]
        studentDob                  <- map["dob"]
        studentContact              <- map["contact"]
        imageUrl                    <- map["profile"]
        lastPresent                 <- map["last_present"]
        lectureAttended             <- map["lectures_attended"]
        totalLecture                <- map["total_lectures"]
        percentage                  <- map["perecentage_att"]
        lastLectureAttendance       = (self.lastPresent == "0") ? "Absent":"Present"
        studentName                 = "\(self.studentFirstName!) \(self.studentMiddleName!) \(self.studentLastName!)"
        editAttendanceStudentName   <- map["student_name"]
        studentName                 = self.studentName == "  " ? editAttendanceStudentName : self.studentName
        attendanceStatus            <- map["att_status"]
        trimmedRollNumber           <- map["trimmed_rollnumber"]
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
