//
//  UserProfile.swift
//  TeachUs
//
//  Created by ios on 3/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//
/*
 
 {
 "user_details": {
 "login_id": "23",
 "f_name": "Harsh",
 "l_name": "Gangar",
 "email": "gangarharsh2515@gmail.com",
 "contact": "9619201282",
 "role_id": "2",
 "profile": ""
 },
 "colleges": [
 {
 "college_id": "1",
 "privilege": "0",
 "college_name": "Rajasthani Sammelan's Ghanshyamdas Saraf College",
 "college_code": "gsc",
 "role_name": "Professor"
 }
 ]
 }
 
 */

import Foundation
import ObjectMapper

class UserProfile:Mappable{
    var loginId:String = ""
    var fistname:String = ""
    var lastName:String = ""
    var email:String = ""
    var contact:String = ""
    var roleId:String = ""
    var profilePicUrl = ""
    var collegeDetails : [CollegeDetails] = []
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.loginId <- map["login_id"]
        self.fistname <- map["f_name"]
        self.lastName <- map["l_name"]
        self.email <- map["contact"]
        self.contact <- map["contact"]
        self.roleId <- map["role_id"]
        self.profilePicUrl <- map["profile"]
        
    }
}
