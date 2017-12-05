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
 
 */

class CollegesListModel:Mappable{
    var collegeId:String = ""
    var collegeName:String = ""
    var sendCollegeOtpUrl:String = ""
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.collegeId <- map["collegeId"]
        self.collegeName <- map["collegeName"]
        self.sendCollegeOtpUrl <- map["sendCollegeOtpUrl"]
    }
}
