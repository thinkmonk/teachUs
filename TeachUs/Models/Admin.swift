//
//  Admin.swift
//  TeachUs
//
//  Created by ios on 4/16/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//


/*
 
 "admin_list": [
 {
 "f_name": "gsc",
 "l_name": "gsc",
 "contact": "9892426688",
 "profile": "",
 "role_id": "3",
 "college_id": "1"
 }
 ]
 
 */

import Foundation
import ObjectMapper

class Admin:Mappable{
    var firstName:String = ""
    var lastName:String = ""
    var contact:String = ""
    var profile:String = ""
    var roleId:String = ""
    var collegeId:String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.firstName <- map["f_name"]
        self.lastName <- map["l_name"]
        self.contact <- map["contact"]
        self.profile <- map["profile"]
        self.roleId <- map["role_id"]
        self.collegeId <- map["college_id"]
    }
    
    
}
