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
    
    var totalLecture:Int?
    var totalPresentCount: Int?
    var overallPercenage:Int?
    var subjectAttendance:[SubjectAttendance] = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.totalLecture <- map["totalLecture"]
        self.totalPresentCount <- map["totalPresentCount"]
        self.overallPercenage <- map["overallPercenage"]
        var subjectAttendanceArray:[[String:Any]] = []
        subjectAttendanceArray <- map["subjectWise"]
        
        if(subjectAttendanceArray.count > 0){
            for subject in subjectAttendanceArray{
                let tempSubject = Mapper<SubjectAttendance>().map(JSON: subject)
                self.subjectAttendance.append(tempSubject!)
            }
        }
    }
}

class SubjectAttendance:Mappable{
    var subjectId:Int?
    var subjectName:String?
    var percentage:Int?
    var presentCount:Int?
    var totalCount:Int?

    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        self.subjectId <- map["subjectId"]
        self.subjectName <- map["subjectName"]
        
        if((map.JSON["percentage"]) != nil){
            self.percentage <- map["percentage"]
        }
        else{
            self.percentage = 0
        }
        self.presentCount <- map["presentCount"]
        self.totalCount <- map["totalCount"]

        
    }

}
