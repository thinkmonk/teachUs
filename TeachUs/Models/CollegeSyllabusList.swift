//
//  CollegeSyllabusList.swift
//  TeachUs
//
//  Created by ios on 5/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 
 {
 "class_list": [
 {
 "course_name": "TYBMS - A",
 "class_id": "1",
 "status": "4"
 },
 
 */

class CollegeSyllabusList:Mappable{
    var courseName:String = ""
    var classId:String = ""
    var status:String = ""
   
    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        self.courseName <- map["course_name"]
        self.classId <- map["class_id"]
        self.status <- map["status"]
    }
    
}
