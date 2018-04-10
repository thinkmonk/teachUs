//
//  ClassList.swift
//  TeachUs
//
//  Created by ios on 4/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper


/*
"class_list": [
{
"class_id": "1",
"class_division": "A",
"year": "1",
"year_name": "FY",
"specialisation": "Finance",
"course_id": "1",
"semester": "1",
"course_name": "FYBMS",
"total_participants": "19"
}
]

*/

class ClassList:Mappable{
    var classId:String = ""
    var classDivision:String = ""
    var year:String = ""
    var yearName:String = ""
    var specialisation:String = ""
    var courseId:String = ""
    var semester:String = ""
    var courseName:String = ""
    var totalParticipants:String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.classId <- map["class_id"]
        self.classDivision <- map["class_division"]
        self.year <- map["year"]
        self.yearName <- map["year_name"]
        self.specialisation <- map["specialisation"]
        self.courseId <- map["course_id"]
        self.semester <- map["semester"]
        self.courseName <- map["course_name"]
        self.totalParticipants <- map["total_participants"]
    }
    
    
    
}
