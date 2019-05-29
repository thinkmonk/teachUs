//
//  URLConstansts.swift
//  TeachUs
//
//  Created by ios on 11/4/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
public struct URLConstants{

    struct AppUrl {
        static let baseURL = "BASE_URL"
        static let baseUrlV1 = "BASE_URL_V1"
    }
    
    struct BaseUrl {
//        static var baseURL = "http://teachusedumation.com/api_production/teachus" //v3
//        #if DEBUG
//        static var baseURL = "http://teachusedumation.com/api/teachus" //v3
//        #endif

//        static let baseURL = "http://zilliotech.com/api/teachus" //v2
//        static let baseURL = "http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus"  //v1`
        //http://teachusedumation.com
        static let baseURL = Bundle.main.object(forInfoDictionaryKey: AppUrl.baseURL) as! String
        static var baseURLV1 = (Bundle.main.object(forInfoDictionaryKey: AppUrl.baseUrlV1) as? String)!

    }
    
    struct Login {
        static let forceUpdateCheck = BaseUrl.baseURLV1 + "/role/device_update"
        static let role = BaseUrl.baseURLV1 + "/role"
        static let checkDetails = BaseUrl.baseURLV1 + "/login/check_details"
        static let sendOtp = BaseUrl.baseURLV1 + "/login/sendotp"
        static let verifyOtp = BaseUrl.baseURLV1 + "/auth/verifyotp"
        static let userDetails = BaseUrl.baseURLV1 + "/login/user_details"
        static let updateUserProfile = BaseUrl.baseURLV1 + "/login/update_user_profile"
    }
    
    struct StudentURL {
        static let getClassAttendance = BaseUrl.baseURLV1 + "/attendance/student_class_attendance"
        static let getAttendanceDetails = BaseUrl.baseURLV1 + "/student/student_attendance"
        static let updateRatings = BaseUrl.baseURLV1 + "/ratings/submit_rating"
        static let professorRatingList = BaseUrl.baseURLV1 + "/ratings/professor_rating_list"
        static let syllabusSubjectStatus = BaseUrl.baseURLV1 + "/syllabus/student_syllabus_subject_status"
        static let getSyllabusSuubjectDetails = BaseUrl.baseURLV1 + "/syllabus/student_detailed_syllabus_status"
        static let getStudentProfileDetails = BaseUrl.baseURLV1 + "/student/student_details"
        static let updateStudentName = BaseUrl.baseURLV1 + "/student/student_name_update_request"
        static let sendOtpForMobileNumberUpdate = BaseUrl.baseURLV1  + "/student/send_auth_password_newcontact"
        static let updateStudentMobileNumber = BaseUrl.baseURLV1  + "/student/verify_auth_password_newcontact"
        static let sendOtpForEmailUpdate = BaseUrl.baseURLV1  + "/student/send_auth_password_newemail"
        static let updateStudentEmail = BaseUrl.baseURLV1 + "/student/verify_auth_password_newemail"
    }
    
    struct ProfessorURL {
        static let getClassList = BaseUrl.baseURLV1 + "/attendance/classlist"
        static let getStudentList = BaseUrl.baseURLV1 + "/attendance/studentlist"
        static let submitAttendance = BaseUrl.baseURLV1 + "/attendance/submit_attendance"
        static let syllabusSubjectStatus = BaseUrl.baseURLV1 + "/syllabus/professor_syllabus_subject_status"
        static let getSyllabusSuubjectDetails = BaseUrl.baseURLV1 + "/syllabus/professor_detailed_syllabus_status"
        static let logsClassList = BaseUrl.baseURLV1 + "/syllabus/professor_class_list"
        static let logDetails = BaseUrl.baseURLV1 + "/syllabus/detailed_log_subject"
        static let topicList = BaseUrl.baseURLV1 + "/syllabus/topic_list"
        static let submitSyllabusCovered = BaseUrl.baseURLV1 + "/syllabus/submit_topic_covered"
        static let getLectureReport = BaseUrl.baseURLV1 + "/syllabus/lecture_report"
        static let mergedAttendanceAndSyllabus = BaseUrl.baseURLV1 + "/attendance/merged_submit_attendance"
        static let mailAttendanceReport = BaseUrl.baseURLV1 + "/auth/professor_student_attendance_verify_auth_password"
        static let mailLogsReport = BaseUrl.baseURLV1 + "/auth/professor_logs_verify_auth_password"
        static let getEditAttendanceData =  BaseUrl.baseURLV1 + "/professor/attendance_list_edit"
        static let submitEditedAttendace = BaseUrl.baseURLV1 + "/professor/attendance_list_update"
        static let getProfessorProfileDetails = BaseUrl.baseURLV1 + "/professor/professor_data"
        static let updateProfessorName = BaseUrl.baseURLV1 + "/professor/professor_name_update_request"
        static let sendOTPForNewContact = BaseUrl.baseURLV1 + "/professor/send_auth_password_newcontact"
        static let verifyOTPForNewContact = BaseUrl.baseURLV1 + "/professor/verify_auth_password_newcontact"
        static let sendOtpForEmailUpdate = BaseUrl.baseURLV1  + "/professor/send_auth_password_newemail"
        static let updateProfessorEmail = BaseUrl.baseURLV1 + "/professor/verify_auth_password_newemail"
        static let getNotesList = BaseUrl.baseURLV1 + "/professor/notes_list"
        static let getNotesDetails = BaseUrl.baseURLV1 + "/professor/notes_list_view"
        static let deleteNotes = BaseUrl.baseURLV1 + "/professor/notes_delete"
    }
    
    
    struct CollegeURL {
        static let getCollegeList = BaseUrl.baseURLV1 + "/college/college_list"
        static let classAttendanceList = BaseUrl.baseURLV1 + "/attendance/college_class_attendance"
        static let classSubjectList = BaseUrl.baseURLV1 + "/syllabus/subject_list"
        static let classStudentLIst = BaseUrl.baseURLV1 + "/attendance/student_attendance_list"
        static let sendAuthPassword = BaseUrl.baseURLV1 + "/Auth/send_auth_password"
        static let verifyauthPassword = BaseUrl.baseURLV1 + "/Auth/verify_auth_password"
        static let sendSmsToStudents = BaseUrl.baseURLV1 + "/Auth/send_sms_student"
        static let sendEmailToStudents = BaseUrl.baseURLV1 + "/Auth/send_mail_student"
        static let addNewEvent = BaseUrl.baseURLV1 + "/events/add_event"
        static let getEventlList = BaseUrl.baseURLV1 + "/events/event_list"
        static let getClassList = BaseUrl.baseURLV1 + "/events/event_class_list"
        static let getStudentList = BaseUrl.baseURLV1 + "/events/event_student_list"
        static let markEventAttendance = BaseUrl.baseURLV1 + "/events/add_event_attendance"
        static let getAdminList =  BaseUrl.baseURLV1 + "/admin/adminlist"
        static let addAmin = BaseUrl.baseURLV1 + "/admin/add_admin"
        static let removeAdmin = BaseUrl.baseURLV1 + "/admin/remove_admin"
        static let classRatingList = BaseUrl.baseURLV1 + "/ratings/class_rating_list"
        static let  ClassProfessorRatingList = BaseUrl.baseURLV1 + "/ratings/class_professor_rating_list"
        static let getProfessorRatingDetails = BaseUrl.baseURLV1 + "/ratings/detailed_professor_rating"
        static let getCollegeSyllabusList = BaseUrl.baseURLV1 + "/syllabus/college_class_syllabus_status"
        static let getCollegeSubjectSyllabusList = BaseUrl.baseURLV1 + "/syllabus/college_syllabus_subject_status"
        static let getCollegeSubjectSyllabusDetails = BaseUrl.baseURLV1  + "/syllabus/college_detailed_syllabus_status"
        static let sendAttendanceReportToEmail = BaseUrl.baseURLV1 + "/auth/professor_student_attendance_verify_auth_password"
        static let verifyFeedbackAuthPassword = BaseUrl.baseURLV1 + "/auth/feedback_verify_auth_password"
        static let getProfessorListForACollege = BaseUrl.baseURLV1 + "/college/professor_subjects"
        static let getLogsSubjectData = BaseUrl.baseURLV1 + "/college/professor_subjects_data"
        static let getcollegeSubjectLogsDetals = BaseUrl.baseURLV1 + "/college/professor_subjects_logs"
        static let getProfileChangeRequests = BaseUrl.baseURLV1 + "/college/requests_data"
        static let updateRequestDetails = BaseUrl.baseURLV1 + "/college/update_data"
    }
    
    struct SyllabusURL {
        static let getCourseList = BaseUrl.baseURLV1 + "/syllabus/course_list"
    }
    
    struct OfflineURL {
        static let getOfflineData = BaseUrl.baseURLV1 + "/offline/get_offline"
    }
    
    struct TeachUsAppStoreLink {
        static let storeLink = "https://itunes.apple.com/in/app/teach-us/id1392613722?mt=8"
    }

}
