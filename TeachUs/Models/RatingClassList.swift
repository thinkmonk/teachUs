//
//  RatingClassList.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

/*

 "class_list": [
 {
 "course_name": "FYBMS",
 "total_rate": "85",
 "avg_rate": "7.1",
 "class_division": "A",
 "class_id": "1"
 }
 ]


*/




import Foundation
import ObjectMapper

class RatingClassList:Mappable, Equatable{
    
    
    var courseName:String = ""
    var totalRate:String = ""
    var averageRating:String = ""
    var classDivision:String = ""
    var classId:String = ""

    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        self.courseName <- map["course_name"]
        self.totalRate <- map["total_participants"]
        self.averageRating <- map["avg_rate"]
        self.classDivision <- map["class_division"]
        self.classId <- map["class_id"]
    }
    
    
    static func == (lhs: RatingClassList, rhs: RatingClassList) -> Bool {
        return lhs.classId == rhs.classId
    }
    
    
}
