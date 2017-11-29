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

    static var sharedUserManager : UserManager {
        let userManager = UserManager()
        let lastUser = DatabaseManager.getEntitesForEntityName("Teacher", sortindId: "name")
        userManager.userTeacher = lastUser.last as? Teacher
        return userManager
    }
    
    
    var user:LoginUserType! {
        let user = UserDefaults.standard.value(forKey: Constants.UserDefaults.loginUserType) as? String
        switch user {
        case "College"?:
            return LoginUserType.College
        case "Professor"?:
            return LoginUserType.Professor
        case "Student"?:
            return LoginUserType.Student
        default:
            return nil
        }
    }
    
    var isAdmin = false
    var isSuperAdmin = false;
    var userName:String = ""
    var userMiddleName:String = ""
    var userLastName:String = ""
    var userFullName:String{
        return "\(self.userName) \(self.userMiddleName) \(self.userLastName)"
    }
    
    var userTeacher:Teacher!
    var teacherProfile:TeacherProfile!
    
    func setAccessToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.accesToken)
        UserDefaults.standard.synchronize()
    }
    
    func getAccessToken() -> String {
        guard let token = UserDefaults.standard.value(forKey: Constants.UserDefaults.accesToken) as? String else {
            return "Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x"
        }
        return token
    }
    
    
    func setLoginUserType(_ type:LoginUserType){
        switch type {
        case .College:
            UserDefaults.standard.set("College", forKey: Constants.UserDefaults.loginUserType)
            
        case .Professor:
            UserDefaults.standard.set("Professor", forKey: Constants.UserDefaults.loginUserType)
            
        case .Student:
            UserDefaults.standard.set("Student", forKey: Constants.UserDefaults.loginUserType)

        }
        UserDefaults.standard.synchronize()
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
    
    func saveTeacherToDb(_ teacher:TeacherProfile){
        userTeacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: DatabaseManager.managedContext) as! Teacher
        
        userTeacher.attendanceUrl = teacher.attendenceUrl
        userTeacher.syllabusStatusUrl = teacher.syllabusStatusUrl
        userTeacher.logsUrl = teacher.logsUrl
        userTeacher.uploadProfilePicUrl = teacher.uploadProfilePicUrl
        userTeacher.role = teacher.userRole
        userTeacher.professorId = Int16(teacher.professorId)
        userTeacher.professorName = teacher.professorName
        userTeacher.professorLastName = teacher.professorLastName
        userTeacher.collegeName = teacher.collegeName
        userTeacher.collegeId = teacher.collegeId
        
        self.saveDbContext()
    }
    
    
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
