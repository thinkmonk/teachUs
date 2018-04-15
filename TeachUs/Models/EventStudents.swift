//
//  EventStudents.swift
//  TeachUs
//
//  Created by ios on 4/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa


/*
 
 "student_list": [
 {
 "student_id": "4",
 "roll_number": "1001",
 "f_name": "Miren",
 "l_name": "Chetan",
 "m_name": "Shah",
 "dob": "2018-02-01",
 "email": "miren@gmail.com",
 "gender": "male",
 "contact": "9819348451",
 "class_id": "1",
 "created_on": "2018-02-12 00:00:00",
 "attendance": "2"
 },
 
 */



class EventStudents:Mappable{
    
    var studentID:String = ""
    var rollNumber:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var middleName:String = ""
    var dob:String = ""
    var email:String = ""
    var gender:String = ""
    var contactNumber:String = ""
    var classId:String = ""
    var createdOn:String = ""
    var fullname:String = ""
    var attendance:Variable<Int> = Variable(0)
    
    required init?(map: Map) {
    
    }
    
     func mapping(map: Map) {
        self.studentID <- map["student_id"]
        self.rollNumber <- map["roll_number"]
        self.firstName <- map["f_name"]
        self.lastName <- map["l_name"]
        self.middleName <- map["m_name"]
        self.dob <- map["dob"]
        self.email <- map["email"]
        self.gender <- map["gender"]
        self.contactNumber <- map["contact"]
        self.classId <- map["class_id"]
        self.createdOn <- map["created_on"]
        var attendance = ""
        attendance <- map["attendance"]
        self.attendance.value = Int(attendance)!
        self.fullname = "\(self.firstName) \(self.middleName) \(self.lastName)"
    }
}
