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
    }
    
    struct Images {
        static let hamburger = "hamburger"
    }
    
    struct  colors {
        static let themeRed = UIColor(red: 198/255, green: 0/255, blue: 0/255, alpha: 1)
        static let themeBlue = UIColor(red: 52/255, green: 175/255, blue: 255/255, alpha: 1)
    }
    
    struct viewControllerId {
        static let professorAttendance = "ProfessorAttedanceViewControllerID"
        static let professorSyllabusStatus = "SyllabusStatusListViewControllerId"
        static let professorLogs = "ProfessorLogsListViewControllerId"
        static let studentList = "StudentAttedanceViewControllerId"
    }
    
    struct UserDefaults {
        static let accesToken = "AppUserAccessToken"
        static let userId = "UserId"
    }
    
    struct NumberConstants {
        static let homeTabBarHeight = 40.0;
    }
    
    struct CustomCellId {
        static let ProfessorCollegeList = "professorCollegeList"
        static let AttendanceCalenderTableViewCellId = "AttendanceCalenderTableViewCellId"
        static let AttendanceStudentListTableViewCellId = "AttendanceStudentListTableViewCellId"
        static let DefaultSelectionTableViewCellId = "DefaultSelectionTableViewCellId"
        static let AttendanceCountTableViewCellId = "AttendanceCountTableViewCellId"

    }
}
