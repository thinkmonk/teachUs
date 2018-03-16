//
//  UserCollegeDetails.swift
//  TeachUs
//
//  Created by ios on 3/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

/*
 "colleges": [
 {
 "college_id": "1",
 "privilege": "0",
 "college_name": "Rajasthani Sammelan's Ghanshyamdas Saraf College",
 "college_code": "gsc",
 "role_name": "Professor"
 }
 ]
 
 */



import Foundation
import ObjectMapper

class UserCollegeDetails:Mappable{
    var collegeId:String = ""
    var privilege:String  = ""
    var collegeName:String = ""
    var collegeCode:String = ""
    var roleName:String = ""
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.collegeId <- map["college_id"]
        self.privilege <- map["privilege"]
        self.collegeName <- map["college_name"]
        self.collegeCode <- map["college_code"]
        self.roleName <- map["role_name"]
    }
}
