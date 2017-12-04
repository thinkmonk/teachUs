//
//  SuperAdminProfile.swift
//  TeachUs
//
//  Created by ios on 12/3/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//


/*
 {
 "role": "SUPERADMIN",
 "collegeId": "1001",
 "collegeName": "ATHARVA COLLEGE",
 "getClassAttendanceUrl": "/college/getClassAttendance/Zmlyc3ROYW1lPW51bGwsbWlkZGxlTmFtZT1udWxsLGxhc3ROYW1lPW51bGwscm9sbD1TVVBFUkFETUlO?collegeId=1001",
 "getClassSyllabusUrl": "/college/getClassSyllabus/Zmlyc3ROYW1lPW51bGwsbWlkZGxlTmFtZT1udWxsLGxhc3ROYW1lPW51bGwscm9sbD1TVVBFUkFETUlO?collegeId=1001",
 "getCourseRatingsUrl": "/college/getCourseRatings/Zmlyc3ROYW1lPW51bGwsbWlkZGxlTmFtZT1udWxsLGxhc3ROYW1lPW51bGwscm9sbD1TVVBFUkFETUlO?collegeId=1001",
 "getEventAttendanceUrl": "/college/getEventList/Zmlyc3ROYW1lPW51bGwsbWlkZGxlTmFtZT1udWxsLGxhc3ROYW1lPW51bGwscm9sbD1TVVBFUkFETUlO?collegeId=1001",
 "getAdminListUrl": "/college/getAdminList/Zmlyc3ROYW1lPW51bGwsbWlkZGxlTmFtZT1udWxsLGxhc3ROYW1lPW51bGwscm9sbD1TVVBFUkFETUlO?collegeId=1001"
 }
 
 */


import Foundation
import ObjectMapper
class SuperAdminProfile:Mappable{
    var userRole = ""
    var collegeId:String = ""
    var collegeName:String = ""
    var classAttendanceURL:String = ""
    var classSyllabusUrl:String = ""
    var courseRatingsUrl:String = ""
    var eventAttendanceUrl:String = ""
    var adminListUrl:String = ""
    var userImage = ""

    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.userRole <- map["role"]
        self.collegeId <- map["collegeId"]
        self.collegeName <- map["collegeName"]
        self.classAttendanceURL <- map["getClassAttendanceUrl"]
        self.classSyllabusUrl <- map["getClassSyllabusUrl"]
        self.courseRatingsUrl <- map["getCourseRatingsUrl"]
        self.eventAttendanceUrl <- map["getEventAttendanceUrl"]
        self.adminListUrl <- map["getAdminListUrl"]
    }
}
