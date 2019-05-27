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
    
    var offlineAppUserData:OfflineData!
    var offlineAppuserCollegeDetails:Offline_Colleges!
    var isUserInOfflineMode:Bool = false //check not to show "work in offline mode" pop-up multiple times
    
    /// Return the type of the role type of the user logged in
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
        let user = DatabaseManager.getEntitesForEntityName("UserDetails", sortindId: "firstName")
        if(user.count > 0){
            self.appUserDetails = user.last as! UserDetails
            self.userName = self.appUserDetails.firstName!
            self.userLastName = self.appUserDetails.lastName!
            let collegeDetailsArray = DatabaseManager.getEntitesForEntityName("CollegeDetails", sortindId: "college_name")
            if(collegeDetailsArray.count > 0){
                self.appUserCollegeArray = collegeDetailsArray as! [CollegeDetails]
            }
            /*
            if(self.appUserCollegeArray.contains(where: {$0.role_id! == "1" }) && ((self.appUserCollegeArray.contains(where: { $0.role_id! == "2"})) || (self.appUserCollegeArray.contains(where: { $0.role_id! == "3"})))){
                self.appUserCollegeArray = self.appUserCollegeArray.filter {$0.role_id != "1"}
            }
 */
            //remove student profile from when professor and college are logged in
            if(self.appUserCollegeArray.contains(where: {$0.role_id! == "1" }) && ((self.appUserCollegeArray.contains(where: { $0.role_id! == "2"})) || (self.appUserCollegeArray.contains(where: { $0.role_id! == "3"})))){
                self.appUserCollegeArray = self.appUserCollegeArray.filter {$0.role_id != "1"}
            }
            
            guard let defaultCollegeName = UserDefaults.standard.value(forKey: Constants.UserDefaults.collegeName) as? String, let defaultRoleName = UserDefaults.standard.value(forKey: Constants.UserDefaults.roleName) as? String
                else {
                    if(self.user == nil) {
                        self.appUserCollegeDetails = self.appUserCollegeArray.first!
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
                    }else
                    {//set up user after login type is known
                        for user in self.appUserCollegeArray {
                            if user.role_id! == "1" && self.user! == LoginUserType.Student{
                                self.appUserCollegeDetails = user
                                break
                            }
                            if user.role_id! == "2" && self.user! == LoginUserType.Professor{
                                self.appUserCollegeDetails = user
                                break
                            }
                            if user.role_id! == "3" && self.user! == LoginUserType.College{
                                self.appUserCollegeDetails = user
                                break
                            }
                        }
                    }
                return
            }
            
            //when default user type is available
            for appuser in self.appUserCollegeArray{
                if appuser.role_name! == defaultRoleName && appuser.college_name! == defaultCollegeName{
                    self.appUserCollegeDetails = appuser
                    switch appuser.role_id!{
                    case "1":
                        UserManager.sharedUserManager.setLoginUserType(.Student)
                        break
                    case "2":
                        UserManager.sharedUserManager.setLoginUserType(.Professor)
                        break
                    case "3":
                        UserManager.sharedUserManager.setLoginUserType(.College)
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
    //When user role is changed
    func setUserBasedOnRole(){
                    switch self.appUserCollegeDetails.role_id!{
                    case "1":
                        UserManager.sharedUserManager.setLoginUserType(.Student)
                        break
                    case "2":
                        UserManager.sharedUserManager.setLoginUserType(.Professor)
                        break
                    case "3":
                        UserManager.sharedUserManager.setLoginUserType(.College)
                        break
                    default:
                        break
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

    
    //MARK:- Offline mode
    func getOfflineData(){
        let manager = NetworkHandler()
        manager.url = URLConstants.OfflineURL.getOfflineData
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let parameters:[String:Any] = [:]
        manager.apiPost(apiName: "Get User Details for offline mode", parameters:parameters, completionHandler: { (result, code, response) in
            if(code == 200){
                self.saveOfflineDataToDb(offlineData: response)
            }
            else{
                let message:String = response["message"] as! String
                
            }

        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    func saveOfflineDataToDb(offlineData:[String:Any]){
        DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineUserData")
        let offlineDetails:OfflineUserData = NSEntityDescription.insertNewObject(forEntityName: "OfflineUserData", into: DatabaseManager.managedContext) as! OfflineUserData
        offlineDetails.data = offlineData as NSObject
        self.saveDbContext()
        self.initOfflineUser()
    }
    
    func initOfflineUser(){
        let dataResponse = DatabaseManager.getEntitesForEntityName(name: "OfflineUserData")
        if(dataResponse.count > 0){
        let dataTransformable:OfflineUserData = (dataResponse.last as? OfflineUserData)!
        let data = dataTransformable.data!
        self.offlineAppUserData = Mapper<OfflineData>().map(JSONObject: data)
        self.userName = (self.offlineAppUserData.profile?.f_name!)!
        self.userLastName = (self.offlineAppUserData.profile?.l_name!)!
        
        guard let defaultCollegeName = UserDefaults.standard.value(forKey: Constants.UserDefaults.offlineCollegeName) as? String
            else {//when default offline user is not available
                if(self.appUserCollegeDetails != nil){
                    self.offlineAppuserCollegeDetails = self.offlineAppUserData.colleges!.filter({$0.college_name == self.appUserCollegeDetails.college_name}).first
                }
                
                if(offlineAppuserCollegeDetails == nil){
                    self.offlineAppuserCollegeDetails = self.offlineAppUserData.colleges!.first!
                }

                return
            }
        
        //when default user is available
        for college in self.offlineAppUserData.colleges!
        {
            if(college.college_name == defaultCollegeName){
                self.offlineAppuserCollegeDetails = college
            }
        }
    }
        
        // ****NO code will be executed after this (return is present in defaultcollegename initialiser) ********
    }
    
    func updateOfflineUserData(){
        DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineUserData")
        let offlineDetails:OfflineUserData = NSEntityDescription.insertNewObject(forEntityName: "OfflineUserData", into: DatabaseManager.managedContext) as! OfflineUserData
        let modifiedData = self.offlineAppUserData.toJSON()
        offlineDetails.data = modifiedData as NSObject
        self.saveDbContext()
        self.initOfflineUser()
    }
    
    //log out un authorised user
    func logOutUser(){
        UserManager.sharedUserManager.setAccessToken("")
        DatabaseManager.deleteAllEntitiesForEntityName(name: "CollegeDetails")
        DatabaseManager.deleteAllEntitiesForEntityName(name: "UserDetails")
        DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineUserData")
        DatabaseManager.saveDbContext()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.collegeName)
        UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.roleName)
        UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.loginUserType)
        UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.accesToken)
        UserDefaults.standard.synchronize()
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.LoginSelectNavBarControllerId) as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}
