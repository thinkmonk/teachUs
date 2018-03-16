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
    }
    
    struct Images {
        static let hamburger = "hamburger"
        static let syllabusInProgress = "In_progress"
        static let syllabusCompleted = "completed"
        static let syllabusNotStarted = "Not_Started"
        static let defaultProfessor = "professor_default"
        static let studentDefault = "student_default"
        static let heartFilled = "heartFilled"
    }
    
    struct  colors {
        static let themeRed = UIColor(red: 198/255, green: 0/255, blue: 0/255, alpha: 1)
        static let themeBlue = UIColor(red: 52/255, green: 175/255, blue: 255/255, alpha: 1)
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
    }
    
    struct UserDefaults {
        static let accesToken = "AppUserAccessToken"
        static let userId = "UserId"
        static let userMobileNumber = "userMobileNumber"
        static let loginUserType = "loginUserType"
        static let userImageURL = "userImage"
    }
    
    struct NumberConstants {
        static let homeTabBarHeight = 40.0
        static let navbarHeight = 65.0
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
    }
    
    struct UserTypeString {
        static let Student = "STUDENT"
        static let Professor = "PROFESSOR"
        static let College = "COLLEGE"
        static let SuperAdmin = "SUPERADMIN"
    }
}
