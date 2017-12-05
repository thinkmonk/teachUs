//
//  UserManager.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import CoreData

class UserManager{
//    static var userManager:UserManager!

    static var sharedUserManager = UserManager()
    
    static var savedUserManager : UserManager {
        let userManager = UserManager()
        if(userManager.user != nil){
            switch userManager.user!{
            case .Student:
                let lastUser = DatabaseManager.getEntitesForEntityName("Student", sortindId: "name")
                userManager.userStudent = lastUser.last as? Student
            case .Professor:
                let lastUser = DatabaseManager.getEntitesForEntityName("Teacher", sortindId: "name")
                userManager.userTeacher = lastUser.last as? Teacher
            case .College:
                break
            }
            sharedUserManager = userManager
        }
        return userManager
    }
    
    var user:LoginUserType! {
    if let user = UserDefaults.standard.value(forKey: Constants.UserDefaults.loginUserType) as? String {
            switch user {
            case Constants.UserTypeString.College:
                return LoginUserType.College
            case Constants.UserTypeString.Professor:
                return LoginUserType.Professor
            case Constants.UserTypeString.Student:
                return LoginUserType.Student
            default:
                return nil
            }
        }
        return nil
    }
    
    var userProfilesArray:[AppUser] = []
    
    var userName:String = ""
    var userMiddleName:String = ""
    var userLastName:String = ""
    var userFullName:String{
        return "\(self.userName) \(self.userMiddleName) \(self.userLastName)"
    }
    
    var userTeacher:Teacher! //model
    var teacherProfile:TeacherProfile! //Db model
    
    var studentProfile:StudentProfile! //model
    var userStudent:Student! //Db model
    
    var superAdminProfile:SuperAdminProfile! //model
    var userSuperAdmin:SuperAdmin! //Db model
    
    func setAccessToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.accesToken)
        UserDefaults.standard.synchronize()
    }
    
    func getAccessToken() -> String {
        guard let token = UserDefaults.standard.value(forKey: Constants.UserDefaults.accesToken) as? String else {
//            return "Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x"
            return "Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA=="
        }
        return token
    }
    
    
    func setLoginUserType(_ type:LoginUserType){
        switch type {
        case .Student:
            UserDefaults.standard.set(Constants.UserTypeString.Student, forKey: Constants.UserDefaults.loginUserType)
            
        case .Professor:
            UserDefaults.standard.set(Constants.UserTypeString.Professor, forKey: Constants.UserDefaults.loginUserType)

        case .College:
            UserDefaults.standard.set(Constants.UserTypeString.College, forKey: Constants.UserDefaults.loginUserType)

        }
        UserDefaults.standard.synchronize()
    }
    
    
    func initLoggedInUser(){
        self.userProfilesArray.removeAll()
        let lastUserStudent = DatabaseManager.getEntitesForEntityName("Student", sortindId: "name")
        if(lastUserStudent.count > 0){
            let appuser = AppUser()
            appuser.userType = Constants.UserTypeString.Student
            self.userStudent = lastUserStudent.last as! Student
            appuser.isActive = self.userStudent.isCurrentUser
            self.userProfilesArray.append(appuser)
        }
        
        let lastUserProfessor = DatabaseManager.getEntitesForEntityName("Teacher", sortindId: "name")
        if(lastUserProfessor.count > 0){
            let appuser = AppUser()
            appuser.userType = Constants.UserTypeString.Professor
            self.userTeacher = lastUserProfessor.last as! Teacher
            appuser.isActive = self.userTeacher.isCurrentUser
            self.userProfilesArray.append(appuser)
        }
        
        
        
        let lastUserSuperAdmin = DatabaseManager.getEntitesForEntityName("SuperAdmin", sortindId: "name")
        if(lastUserSuperAdmin.count > 0){
            let appuser = AppUser()
            appuser.userType = Constants.UserTypeString.College
            self.userSuperAdmin = lastUserSuperAdmin.last as! SuperAdmin
            appuser.isActive = self.userSuperAdmin.isCurrentUser
            self.userProfilesArray.append(appuser)
        }
    }
    
    func setUserId(_ id:String){
        UserDefaults.standard.set(id, forKey: Constants.UserDefaults.userId)
        UserDefaults.standard.synchronize()
    }
    
    func getUserId() -> String{
        guard let userId = UserDefaults.standard.value(forKey: Constants.UserDefaults.userId) as? String else {
            return "0"
        }
        return userId
    }
    
    func saveMobileNumber(_ mobileNumber:String){
        UserDefaults.standard.set(mobileNumber, forKey: Constants.UserDefaults.userMobileNumber)
        UserDefaults.standard.synchronize()
    }
    
    func getUserMobileNumber() -> String{
        guard let userMobileNumber = UserDefaults.standard.value(forKey: Constants.UserDefaults.userMobileNumber) as? String else {
            return "1"
        }
        return userMobileNumber
    }
    
    func saveUserImageURL(_ imageULl:String){
        UserDefaults.standard.set(imageULl, forKey: Constants.UserDefaults.userImageURL)
        UserDefaults.standard.synchronize()
    }
    
    func getUserImageURL() -> String{
        guard let userImageURL = UserDefaults.standard.value(forKey: Constants.UserDefaults.userImageURL) as? String else {
            return ""
        }
        return userImageURL
    }
    
    func saveTeacherToDb(_ teacher:[String:Any]){
        userTeacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: DatabaseManager.managedContext) as! Teacher
        
        userTeacher.role = teacher["role"] as? String
        userTeacher.syllabusStatusUrl = teacher["syllabusStatusUrl"] as? String
        userTeacher.logsUrl = teacher["logsUrl"] as? String
        userTeacher.uploadProfilePicUrl = teacher["uploadProfilePicUrl"] as? String
        userTeacher.attendanceUrl = teacher["attendenceUrl"] as? String
        userTeacher.professorId = (teacher["professorId"] as? Int16)!
        userTeacher.professorName = teacher["professorName"] as? String
        userTeacher.professorLastName = teacher["professorLastName"] as? String
        userTeacher.collegeName = teacher["collegeName"] as? String
        userTeacher.collegeId = teacher["collegeId"] as? String
        
        let user = AppUser()
        user.user = userTeacher
        user.userType = "PROFESSOR"
        if(self.user == LoginUserType.Professor){
            user.isActive = true
            userTeacher.isCurrentUser = true
        }
        self.userProfilesArray.append(user)
        self.saveDbContext()

    }
    
    /*
    {
    "role": "PROFESSOR",
    "professorId": 3,
    "professorName": "Harsh",
    "professorLastName": "Gangar",
    "collegeId": "1003",
    "collegeName": "Rajasthani Sammelans Ghanshyamdas Saraf Colle",
    "attendenceUrl": "/teacher/getCollegeSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
    "syllabusStatusUrl": "/teacher/getSyllabusSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
    "logsUrl": "/teacher/getLogsSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
    "uploadProfilePicUrl": "/teacher/uploadImage/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3",
    "uploadProfilePicBase64Url": "/teacher/uploadImageBase64/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9WCxsYXN0TmFtZT1HYW5nYXIscm9sbD1QUk9GRVNTT1IsaWQ9Mw==?professorId=3"
    }
     */
    
    func saveStudentToDb(_ student:[String:Any]){
        userStudent = NSEntityDescription.insertNewObject(forEntityName: "Student", into: DatabaseManager.managedContext) as! Student
        
        userStudent.role = student["role"] as? String
        userStudent.studentId = (student["studentId"] as? Int16)!
        userStudent.studentName = student["studentName"] as? String
        userStudent.studentLastName = student["studentLastName"] as? String
        userStudent.collegeName = student["collegeName"] as? String
        userStudent.collegeId = student["collegeId"] as? String
        userStudent.attendanceUrl = student["attendenceUrl"] as? String
        userStudent.sllyabusStatusUrl = student["syllabusStatusUrl"] as? String
        userStudent.ratingsUrl = student["ratingsUrl"] as? String
        userStudent.uploadProfilePicUrl = student["uploadProfilePicUrl"] as? String
        let user = AppUser()
        user.user = userStudent
        user.userType = "STUDENT"
        if(self.user == LoginUserType.Student){
            user.isActive = true
            userStudent.isCurrentUser = true
        }
        self.userProfilesArray.append(user)
        self.saveDbContext()

    }
    
    /*
     {
     "role": "STUDENT",
     "studentId": 4,
     "studentName": "Harsh",
     "studentLastName": "Gangar",
     "collegeId": "1001",
     "collegeName": "ATHARVA COLLEGE",
     "attendenceUrl": "/student/getAttendence/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4",
     "syllabusStatusUrl": "/student/getSyllabusSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4",
     "ratingsUrl": "/student/getRatingsSummary/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4",
     "uploadProfilePicUrl": "/student/uploadImageBase64/Zmlyc3ROYW1lPUhhcnNoLG1pZGRsZU5hbWU9RyxzdXJOYW1lPUdhbmdhcixyb2xsPVNUVURFTlQsaWQ9NA==?studentId=4"
     }
     ]
    */
    
    func saveSuperAdminToDb(_ superAdmin:[String:Any]) {
        userSuperAdmin = NSEntityDescription.insertNewObject(forEntityName: "SuperAdmin", into: DatabaseManager.managedContext) as! SuperAdmin
        userSuperAdmin.role = superAdmin["role"] as? String
        userSuperAdmin.collegeId = superAdmin["collegeId"] as? String
        userSuperAdmin.collegeName = superAdmin["collegeName"] as? String
        userSuperAdmin.classAttendanceUrl = superAdmin["getClassAttendanceUrl"] as? String
        userSuperAdmin.classSyllabusUrl = superAdmin["getClassSyllabusUrl"] as? String
        userSuperAdmin.courseRatingsUrl = superAdmin["getCourseRatingsUrl"] as? String
        userSuperAdmin.eventAttendanceUrl = superAdmin["getEventAttendanceUrl"] as? String
        userSuperAdmin.adminListUrl = superAdmin["getAdminListUrl"] as? String
        let user = AppUser()
        user.user = userSuperAdmin
        user.userType = "SUPERADMIN"
        if(self.user == LoginUserType.College){
            user.isActive = true
            userSuperAdmin.isCurrentUser = true
        }
        self.userProfilesArray.append(user)
        self.saveDbContext()
        
    }
    
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
    
    
    func saveDbContext(){
        let managedContext = DatabaseManager.managedContext
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

}
