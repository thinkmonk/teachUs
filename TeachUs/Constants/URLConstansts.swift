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
        static let baseURL = "http://ec2-52-40-212-186.us-west-2.compute.amazonaws.com:8081/teachus/" //v2
//        static let baseURL = "http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus"  //v1
    }
    
    struct TecacherURL {
        static let collegeSummary = BaseUrl.baseURL + "/teacher/getCollegeSummary/"
        static let getEnrolledStudents = BaseUrl.baseURL + "/teacher/getEnrolledStudentList"
        static let getTopics = BaseUrl.baseURL + "/teacher/getTopics/"
        static let getSyllabusSummary = BaseUrl.baseURL + "/teacher/getSyllabusSummary/"
    }
    
    struct StudentURL {
        static let getAttendence =  BaseUrl.baseURL + "/student/getAttendence/"
        static let getSyllabusSummary = BaseUrl.baseURL + "/student/getSyllabusSummary/"
        static let getRatingsSummary = BaseUrl.baseURL + "/student/getRatingsSummary/"
        
    }
    
    struct CollegeURL {
        
    }
    
    struct SuperAdminURL {
        
    }

}
