//
//  StudentAttendance.swift
//  TeachUs
//
//  Created by ios on 11/20/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

/*

{
    "totalLecture": 4,
    "totalPresentCount": 2,
    "overallPercenage": 50,
    "subjectWise": [
    {
    "subjectId": 1,
    "subjectName": "ETHICS",
    "percentage": 100,
    "presentCount": 1,
    "totalCount": 1
    },
    {
    "subjectId": 4,
    "subjectName": "RISK MANAGEMENT",
    "percentage": 33,
    "presentCount": 1,
    "totalCount": 3
    }
    ]
}

*/
import Foundation
import ObjectMapper
class  StudentAttendance:Mappable{
    
    var totalLecture:String! = ""
    var totalPresentCount: String! = ""
    var overallPercenage:String! = ""
    var subjectAttendance:[SubjectAttendance] = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.totalLecture <- map["total_lectures"]
        self.totalPresentCount <- map["attended_lectures"]
        self.overallPercenage <- map["overall_percentage"]
        
        
        
        var subjectAttendanceArray:[[String:Any]] = []
        subjectAttendanceArray <- map["attendancelist"]
        
        if(subjectAttendanceArray.count > 0){
            for subject in subjectAttendanceArray{
                let tempSubject = Mapper<SubjectAttendance>().map(JSON: subject)
                self.subjectAttendance.append(tempSubject!)
            }
        }
    }
}

class SubjectAttendance:Mappable{
    var subjectId:String! = ""
    var subjectName:String! = ""
    var percentage:String! = ""
    var presentCount:String! = ""
    var totalCount:String! = ""
    var subjectCode:String! = ""
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.subjectId <- map["subject_id"]
        self.subjectName <- map["subject_name"]
        self.percentage <- map["percent"]
        self.presentCount <- map["attended_lectures"]
        self.totalCount <- map["total_lectures"]
        self.subjectCode <- map["subject_code"]
    }
}
