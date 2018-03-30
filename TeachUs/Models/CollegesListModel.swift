//
//  CollegeList.swift
//  TeachUs
//
//  Created by ios on 12/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 
 {
 "collegeDetails": [
 {
 "collegeId": "1",
 "collegeName": "ATHARVA COLLEGE",
 "sendCollegeOtpUrl": "/college/genOtp?collegeId=1&contactNumber="
 }
 ]
 }
 
 {
 address = "Swami Vivekanand Road, Malad West \U00b7 022 2873 3807";
 city = MUMBAI;
 "college_code" = gsc;
 "college_id" = 1;
 "college_name" = "Rajasthani Sammelan's Ghanshyamdas Saraf College";
 "created_on" = "2018-02-20 00:00:00";
 "university_id" = 1;
 }
 
 */

class CollegesListModel:Mappable{
    var addreess:String = ""
    var city:String = ""
    var collegeCode:String = ""
    var collegeId:String = ""
    var collegeName:String = ""
    var createdOn:String = ""
    var universityId:String = ""
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.addreess <- map["address"]
        self.city <- map["city"]
        self.collegeCode <- map["college_code"]
        self.collegeId <- map["college_id"]
        self.collegeName <- map["college_name"]
        self.collegeName <- map[""]
        self.createdOn <- map["created_on"]
        self.universityId <- map["university_id"]
    }
}
