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
        static let updateUserProfile = BaseUrl.baseURL + "/login/update_user_profile"
    }
    
    struct StudentURL {
        static let getClassAttendance = BaseUrl.baseURL + "/attendance/student_class_attendance"
        static let updateRatings = "TBA"
    }
    
    struct ProfessorURL {
        static let getClassList = BaseUrl.baseURL + "/attendance/classlist"
        static let getStudentList = BaseUrl.baseURL + "/attendance/studentlist"
        static let submitAttendance = BaseUrl.baseURL + "/attendance/submit_attendance"
    }
    
    
    struct CollegeURL {
        static let getCollegeList = BaseUrl.baseURL + "/college/college_list"
        static let classAttendanceList = BaseUrl.baseURL + "/attendance/college_class_attendance"
        static let classSubjectList = BaseUrl.baseURL + "/syllabus/subject_list"
        static let classStudentLIst = BaseUrl.baseURL + "/attendance/student_attendance_list"
        static let sendAuthPassword = BaseUrl.baseURL + "/Auth/send_auth_password"
        static let verifyauthPassword = BaseUrl.baseURL + "/Auth/verify_auth_password"
        static let sendSmsToStudents = BaseUrl.baseURL + "/Auth/send_sms_student"
        static let sendEmailToStudents = BaseUrl.baseURL + "/Auth/send_mail_student"
        static let addNewEvent = BaseUrl.baseURL + "/events/add_event"
        static let getEventlList = BaseUrl.baseURL + "/events/event_list"
        static let getClassList = BaseUrl.baseURL + "/events/event_class_list"
        static let getStudentList = BaseUrl.baseURL + "/events/event_student_list"
        static let markEventAttendance = BaseUrl.baseURL + "/events/add_event_attendance"
        static let getAdminList =  BaseUrl.baseURL + "/admin/adminlist"
        static let addAmin = BaseUrl.baseURL + "/admin/add_admin"
        static let removeAdmin = BaseUrl.baseURL + "/admin/remove_admin"
    }
    
    struct SuperAdminURL {
        
    }

}
