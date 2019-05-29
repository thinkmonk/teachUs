//
//  Constants.swift
//  TeachUs
//
//  Created by ios on 10/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation

public struct Constants {
    struct segues {
        static let toLoginView = "loginSelect"
        static let markPortionCompleted = "markPortionCompleted"
        static let syllabusStatusDetails = "syllabusStatusDetails"
        static let SyllabusDetails = "toSyllabusDetails"
        static let viewRtings = "toViewRatings"
        static let toLoginSelect = "toLoginSelect"
        static let toHomeTabVC = "toHomeTabVC"
        static let toCollegeAttendanceDetail = "toCollegeAttendanceDetail"
        static let toClassList = "toClassList"
        static let toStudentList = "toStudentList"
        static let toProfessorRatingList = "toProfessorRatingList"
        static let toRatingDetails = "toRatingDetails"
        static let toLectureReport = "toLectureReport"
        
        
        static let toOfflineHomeTabsVC = "toOfflineHomeTabsVC"
        static let toOfflineMarkPortion = "offlineMarkPortion"
        static let toStudentAttendanceDetails = "toStudentAttendanceDetails"
        static let toEditProfile = "toEditProfile"
        static let toEditProfileDetails = "toEditProfileDetails"
        static let toProfileChangeRequestDetials = "toProfileChangeRequestDetials"
        static let toNotesDetails = "toNotesDetails"
    }
    
    struct Images {
        static let hamburger = "hamburger"
        static let syllabusInProgress = "In_progress"
        static let syllabusCompleted = "completed"
        static let syllabusNotStarted = "Not_Started"
        static let defaultProfessor = "professor_default"
        static let studentDefault = "student_default"
        static let heartFilled = "heartFilled"
        static let collegeDefault = "college_default"
        static let calendarWhite = "calender"
        static let defaultMale = "defaule_male"
    }
    
    struct  colors {
        static let themeRed = UIColor(red: 198/255, green: 0/255, blue: 0/255, alpha: 1)
        static let themeBlue = UIColor(red: 52/255, green: 175/255, blue: 255/255, alpha: 1)
        static let themePurple = UIColor(red: 108/255, green: 96/255, blue: 200/255, alpha: 1)
        static let themeLightBlue = UIColor(red: 237/255, green: 243/255, blue: 247/255, alpha: 1)

    }
    
    struct viewControllerId {
        static let professorAttendance = "ProfessorAttedanceViewControllerID"
        static let professorSyllabusStatus = "SyllabusStatusListViewControllerId"
        static let professorLogs = "ProfessorLogsListViewControllerId"
        static let studentList = "StudentsListViewControllerId"
        static let syllabusDetails = "SyllabusDetailsViewControllerId"
        static let studentAttendace = "StudentAttedanceViewControllerId"
        static let professorRating = "TeachersRatingViewControllerId"
        static let MarkRating = "MarkRatingViewControllerId"
        static let LogsDetail = "LogsDetailViewControllerId"
        static let loginSelectVC = "LoginSelectViewControllerId"
        static let LoginSelectNavBarControllerId = "LoginSelectNavBarControllerId"
        static let EditProfilePictureViewControllerId = "EditProfilePictureViewControllerId"
        static let CollegeAttendanceListViewControllerId = "CollegeAttendanceListViewControllerId"
        static let CollegeSyllabusStatusViewControllerId = "CollegeSyllabusStatusViewControllerId"
        static let CollegeAttedanceDetailViewControllerId = "CollegeAttedanceDetailViewControllerId"
        static let CollegeAttendanceMailReportViewControllerId = "CollegeAttendanceMailReportViewControllerId"
        static let EventAttendanceListViewControllerId = "EventAttendanceListViewControllerId"
        static let AddNewEventViewControllerId = "AddNewEventViewControllerId"
        static let AddRemoveAdminViewControllerId = "AddRemoveAdminViewControllerId"
        static let CollegeClassRatingListViewControllerId = "CollegeClassRatingListViewControllerId"
        static let OfflineClassProfessorAttendance = "OfflineClassProfessorAttendance"
        static let OfflineHomeViewController = "OfflineHomeViewController"
        static let OfflineStudentsListViewControllerId = "OfflineStudentsListViewControllerId"
        static let UploadOfflineDataViewControllerId = "UploadOfflineDataViewControllerId"
        static let CollegeLogsProfessorListViewControllerId = "CollegeLogsProfessorListViewControllerId"
        static let ProfileChangeRequestsViewControllerId = "ProfileChangeRequestsViewControllerid"
        static let ProfessorNotesSubjectListViewControllerId = "ProfessorNotesSubjectListViewControllerId"
    }
    
    struct UserDefaults {
        static let accesToken = "AppUserAccessToken"
        static let userId = "UserId"
        static let userMobileNumber = "userMobileNumber"
        static let loginUserType = "loginUserType"
        static let userImageURL = "userImage"
        static let collegeName = "collegeName"
        static let roleName = "roleName"
        static let offlineCollegeName = "offlineCollegeName"
    }
    
    struct NumberConstants {
        static let homeTabBarHeight = 44.0
        static let navbarHeight = 65.0
        static let cornerRadius = 3
    }
    
    struct CustomCellId {
        static let ProfessorCollegeList = "professorCollegeList"
        static let AttendanceCalenderTableViewCellId = "AttendanceCalenderTableViewCellId"
        static let AttendanceStudentListTableViewCellId = "AttendanceStudentListTableViewCellId"
        static let DefaultSelectionTableViewCellId = "DefaultSelectionTableViewCellId"
        static let AttendanceCountTableViewCellId = "AttendanceCountTableViewCellId"
        static let TopicDetailsTableViewCellId = "TopicDetailsTableViewCellId"
        static let SyllabusStatusTableViewCellId = "SyllabusStatusTableViewCellId"
        static let SyllabusDetailsTableViewCellId = "SyllabusDetailsTableViewCellId"
        static let TeacherDetailsTableViewCellId = "TeacherDetailsTableViewCellId"
        static let TeacherProfileTableViewCellId = "TeacherProfileTableViewCellId"
        static let RatingTitleTableViewCellId = "RatingTitleTableViewCellId"
        static let RatingTopicsTableViewCellId = "RatingTopicsTableViewCellId"
        static let LogsDetailTableViewCellId = "LogsDetailTableViewCellId"
        static let leftMenuCell = "leftMenuCell"
        static let StudentProfileTableViewCellId = "StudentProfileTableViewCellId"
        static let EventListTableViewCellId = "EventListTableViewCellId"
        static let ClassListTableViewCellId = "ClassListTableViewCellId"
        static let EventStudentListTableViewCellId = "EventStudentListTableViewCellId"
        static let ProfessorRatingProfileTableViewCellId = "ProfessorRatingProfileTableViewCellId"
        static let LectureReportCellId = "lectureReportCellId"
        static let LectureReportTopicsCoveredCellId = "lectureReportTopicsCoveredCellId"
        static let CollegeSyllabusTableViewCellId = "CollegeSyllabusTableViewCellId"
        static let addRemoveAdminCell = "AddRemoveAdminTableViewCellId"
        static let studentAttendanceDetailsHeader = "AttendanceDetailsHeaderTableViewCellId"
        static let studentAttendanceDetails = "AttendanceDetailsValuesTableViewCellId"
        static let profileDetailsEditTableViewCell = "ProfileDetailsEditTableViewCellId"
        static let profileStudentIdTableViewCell = "ProfileStudentIdTableViewCellId"
        static let profileChangeRequestTableViewCellId = "ProfileChangeRequestTableViewCellId"
        static let notesListCellId = "notesListCellId"
        static let notesDetailsCellId = "notesDetailsTableViewCellId"
    }
    
    struct UserTypeString {
        static let Student = "STUDENT"
        static let Professor = "LECTURER"
        static let College = "COLLEGE"
        static let SuperAdmin = "SUPERADMIN"
    }
    
    struct  CustomErrorCodes {
        static let noInternet = 01
    }
    
    struct DatabaseEntities {
        static let AttendanceRequest = "AttendanceRequest"
        static let CollegeDetails = "CollegeDetails"
        static let OfflineApiRequest = "OfflineApiRequest"
        static let OfflineUserData = "OfflineUserData"
        static let UserDetails = "UserDetails"
    }
}

struct AppUserRole {
    static let student = "1"
    static let professor = "2"
    static let college = "3"
}
