//
//  URLConstansts.swift
//  TeachUs
//
//  Created by ios on 11/4/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
public struct URLConstants{

    struct BaseUrl {
        static let baseURL = "http://zilliotech.com/api/teachus" //v2
//        static let baseURL = "http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus"  //v1`
    }
    
    struct Login {
        static let role = BaseUrl.baseURL + "/role"
        static let checkDetails = BaseUrl.baseURL + "/login/check_details"
        static let sendOtp = BaseUrl.baseURL + "/login/sendotp"
        static let verifyOtp = BaseUrl.baseURL + "/auth/verifyotp"
        static let userDetails = BaseUrl.baseURL + "/login/user_details"
    }
    
    struct TecacherURL {
        static let verifyTeacher = BaseUrl.baseURL + "/teacher/verifyTeacher"
        static let generateOtp = BaseUrl.baseURL + "/teacher/genOtp"
        static let validateOtp = BaseUrl.baseURL + "/teacher/validateOtp"
        static let collegeSummary = BaseUrl.baseURL + "/teacher/getCollegeSummary/"
        static let getEnrolledStudents = BaseUrl.baseURL + "/teacher/getEnrolledStudentList"
        static let getTopics = BaseUrl.baseURL + "/teacher/getTopics/"
        static let getSyllabusSummary = BaseUrl.baseURL + "/teacher/getSyllabusSummary/"
    }
    
    struct StudentURL {
        static let verifyStudent = BaseUrl.baseURL + "/student/verifyStudent"
        static let generateOtp = BaseUrl.baseURL + "/student/genOtp"
        static let validateOtp = BaseUrl.baseURL + "/student/validateOtp"
        static let getAttendence =  BaseUrl.baseURL + "/student/getAttendence/"
        static let getSyllabusSummary = BaseUrl.baseURL + "/student/getSyllabusSummary/"
        static let getRatingsSummary = BaseUrl.baseURL + "/student/getRatingsSummary/"
        static let updateRatings = BaseUrl.baseURL + "/student/updateRatings/"

        
    }
    
    struct CollegeURL {
        static let getCollegeList = BaseUrl.baseURL + "/college/getCollegeList"
    }
    
    struct SuperAdminURL {
        
    }

}
