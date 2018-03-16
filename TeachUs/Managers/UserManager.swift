//
//  UserManager.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

class UserManager{
//    static var userManager:UserManager!

    static var sharedUserManager = UserManager()
    var userRole:UserRole!
    var appUserDetails:UserDetails!
    var appUserCollegeDetails:CollegeDetails!
    var appUserCollegeArray:[CollegeDetails]! = []
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
    var userEmail:String = ""
    var userName:String = ""
//    var userMiddleName:String = ""
    var userLastName:String = ""
    var userFullName:String{
        return "\(self.userName) \(self.userLastName)"
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
            return ""
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
        
        
        let user = DatabaseManager.getEntitesForEntityName("UserDetails", sortindId: "firstName")
        if(user.count > 0){
            self.appUserDetails = user.last as! UserDetails
            self.userName = self.appUserDetails.firstName!
            self.userLastName = self.appUserDetails.lastName!
            let collegeDetailsArray = DatabaseManager.getEntitesForEntityName("CollegeDetails", sortindId: "college_name")
            if(collegeDetailsArray.count > 0){
                self.appUserCollegeArray = collegeDetailsArray as! [CollegeDetails]
            }
            self.appUserCollegeDetails = self.appUserCollegeArray.last!
            switch self.appUserCollegeArray.first?.role_id!{
            case "1"?:
                UserManager.sharedUserManager.setLoginUserType(.Student)
                break
            case "2"?:
                UserManager.sharedUserManager.setLoginUserType(.Professor)
                break
            case "3"?:
                UserManager.sharedUserManager.setLoginUserType(.College)
                break
            default:
                break
            }
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
    
/*
     "user_details": {
     "login_id": "19",
     "f_name": "Jaimin ",
     "l_name": "Shah",
     "email": "shahjmn@gmail.com",
     "contact": "9773608085",
     "profile": "http://zilliotech.com/api/profile/195a9bc0c4a4ab1.jpg"
     }
 */
    
    
    func saveUserDetailsToDb(_ userResponse:[String:Any]) {
       DatabaseManager.deleteAllEntitiesForEntityName(name: "UserDetails")
        guard let appUser = userResponse["user_details"] as? [String:Any]  else {
            return
        }
        self.appUserDetails = NSEntityDescription.insertNewObject(forEntityName: "UserDetails", into: DatabaseManager.managedContext) as! UserDetails
        self.appUserDetails.login_id = (appUser["login_id"] as! String)
        self.appUserDetails.firstName = appUser["f_name"] as? String
        self.appUserDetails.lastName = appUser["l_name"] as? String
        self.appUserDetails.email = appUser["email"] as? String
        self.appUserDetails.contact = appUser["contact"] as? String
//        self.appUserDetails.roleId = appUser["role_id"] as? String
        self.appUserDetails.profilePicUrl = appUser["profile"] as? String
        guard let userCollegeArray = userResponse["colleges"] as? [[String:Any]] else {
            self.saveDbContext()
            return
        }
        DatabaseManager.deleteAllEntitiesForEntityName(name: "CollegeDetails")
        for userCollege in userCollegeArray{
            self.saveUserCollege(college: userCollege)
            self.appUserCollegeDetails = self.appUserCollegeArray.first!
        }
    }
  
    
    /*
     {
     "role_id": "1",
     "college_id": "1",
     "privilege": "0",
     "college_name": "Rajasthani Sammelan's Ghanshyamdas Saraf College",
     "college_code": "gsc",
     "role_name": "Student"
     }
 */
    func saveUserCollege(college:[String:Any]){
        
        let collegeDetails:CollegeDetails = NSEntityDescription.insertNewObject(forEntityName: "CollegeDetails", into: DatabaseManager.managedContext) as! CollegeDetails
        collegeDetails.role_id = college["role_id"] as? String
        collegeDetails.college_id = college["college_id"] as? String
        collegeDetails.privilege = college["privilege"] as? String
        collegeDetails.college_name = college["college_name"] as? String
        collegeDetails.college_code = college["college_code"] as? String
        collegeDetails.role_name = college["role_name"] as? String
        self.appUserCollegeArray.append(collegeDetails)
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
