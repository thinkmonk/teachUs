//
//  UserControls.swift
//  TeachUs
//
//  Created by iOS on 12/04/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation

/*
 
 (
             {
         id = 1;
         user = "Attendance (Report)";
     },
             {
         id = 2;
         user = "Attendance (Event)";
     },
             {
         id = 3;
         user = Syllabus;
     },
             {
         id = 4;
         user = "Add/Remove Admin";
     },
             {
         id = 5;
         user = Feedback;
     },
             {
         id = 6;
         user = Logs;
     },
             {
         id = 7;
         user = Notice;
     },
             {
         id = 8;
         user = Notification;
     },
             {
         id = 9;
         user = Notes;
     },
             {
         id = 10;
         user = Request;
     }
 )
 */


enum UserTabControls:Int, CaseIterable{
    case atendanceReport = 1
    case attendanceEvent = 2
    case syllabus        = 3
    case addRemoveAdmin  = 4
    case feedbcak        = 5
    case logs            = 6
    case notice          = 7
    case notification    = 8
    case notes           = 9
    case request         = 10
    case scheduler       = 11
    case logout          = 12
    
    
    var titleName:String{
        switch self {
        case .atendanceReport: return "Attendance (Report)"
            
        case .attendanceEvent: return "Attendance (Event)"
            
        case .syllabus: return "Syllabus"
            
        case .addRemoveAdmin: return "Add/Remove Admin"
            
        case .feedbcak: return "Feedback"
            
        case .logs: return "Logs"
            
        case .notice: return "Notice"
            
        case .notification: return "Notification"
            
        case .notes: return "Notes"
            
        case .request: return "Request"
        case .logout : return "Logout"
        case .scheduler: return "Schedule"
        }
    }
    //["attendanceReport", "syllabusStatusEvent", "syllabus", "addRemoveAdmin","feedback", "logs","notice", "notification", "notes", "request", "logout"]
    var imageName:String{
        switch self {
        case .atendanceReport   : return "attendanceReport"
            
        case .attendanceEvent   : return "syllabusStatusEvent"
            
        case .syllabus          : return "syllabus"
            
        case .addRemoveAdmin    : return "addRemoveAdmin"
            
        case .feedbcak          : return "feedback"
            
        case .logs              : return "logs"
            
        case .notice            : return "notice"
            
        case .notification      : return "notification"
            
        case .notes             : return "notes"
            
        case .request           : return "request"
            
        case .logout            : return "logout"
            
        case .scheduler         : return "logout"
        }
    }
}
