//
//  ViewController.swift
//  TeachUs
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

enum LoginUserType:String {
    case student = "1"
    case professor = "2"
    case college = "3"
    case parents = "4"
    case exam = "5"
    
    var userTypeString:String{
        switch self {
        case .student: return Constants.UserTypeString.Student
        case .professor: return Constants.UserTypeString.Professor
        case .college: return Constants.UserTypeString.College
        case .parents: return Constants.UserTypeString.Parents
        case .exam: return Constants.UserTypeString.Parents
        }
    }
}

class LoginSelectViewController: BaseViewController {
    var arrayUserRoles:[UserRole] = []
    var userType:LoginUserType!
    var roleStudent:UserRole!
    var roleProfessor:UserRole!
    var roleCollege:UserRole!
    var roleParents:UserRole!
    var roleExam:UserRole!
    
    @IBOutlet weak var buttonExam: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultBackGroundImage()
        self.navigationController?.navigationBar.isHidden = false
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        self.getRoleList()
        self.buttonExam.roundedBlueButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: UIColor.white)
    }
    
    func getRoleList(){
        let manager = NetworkHandler()
        //http://zilliotech.com/api/teachus/role
        manager.url = URLConstants.Login.role
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get Role for all user", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            let userRoleDict:[Any] = response["roles"] as! [Any]
            for user in userRoleDict{
                let userRoleDict:[String:Any] = user as! [String:Any]
                let userRoleIdString:String = userRoleDict["role_id"] as! String
                switch userRoleIdString{
                case "1":
                    self.roleStudent = Mapper<UserRole>().map(JSONObject: user)!
                    break
                case "2":
                    self.roleProfessor = Mapper<UserRole>().map(JSONObject: user)!
                    break
                case "3":
                    self.roleCollege = Mapper<UserRole>().map(JSONObject: user)!
                    break
                case "4":
                    self.roleParents = Mapper<UserRole>().map(JSONObject: user)!
                    break
                case "5":
                    self.roleExam = Mapper<UserRole>().map(JSONObject: user)!
                    break
                default:
                    break
                }
            }
            
            if let contact = response["contact"] as? String,
                let email = response["email"] as? String,
                let body = response["body"] as? String{
                UserManager.sharedUserManager.unauthorisedUser.contact = contact
                UserManager.sharedUserManager.unauthorisedUser.email   = email
                UserManager.sharedUserManager.unauthorisedUser.body    = body
            }
            
            self.buttonExam.isHidden = self.roleExam == nil
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == Constants.CustomErrorCodes.noInternet){
                
                self.showErrorAlert(.NoInternet, retry: { (retry) in
                    if(retry){
                        self.getRoleList()
                    }
                })
            }
            print(errorMessage)
        }
    }

    @IBAction func loginStudent(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.student)
        UserManager.sharedUserManager.userRole = roleStudent
        if ForceUpdateManager.sharedForceUpdateManager.checkMaintainenceFlag(){
            self.performSegue(withIdentifier: Constants.segues.profileTomaintainence, sender: self)
        }else{
            self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
        }
    }
    
    @IBAction func loginProfessor(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.professor)
        UserManager.sharedUserManager.userRole = roleProfessor
        if ForceUpdateManager.sharedForceUpdateManager.checkMaintainenceFlag(){
            self.performSegue(withIdentifier: Constants.segues.profileTomaintainence, sender: self)
        }else{
            self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
        }
    }

    @IBAction func loginCollege(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.college)
        UserManager.sharedUserManager.userRole = roleCollege
        if ForceUpdateManager.sharedForceUpdateManager.checkMaintainenceFlag(){
            self.performSegue(withIdentifier: Constants.segues.profileTomaintainence, sender: self)
        }else{
            self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
        }
    }
    
    
    @IBAction func loginParents(_ sender:Any){
        UserManager.sharedUserManager.setLoginUserType(.parents)
        UserManager.sharedUserManager.userRole = roleParents
        if ForceUpdateManager.sharedForceUpdateManager.checkMaintainenceFlag(){
            self.performSegue(withIdentifier: Constants.segues.profileTomaintainence, sender: self)
        }else{
            self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
        }

    }
    
    @IBAction func loginExam(_ sender:Any){
        UserManager.sharedUserManager.setLoginUserType(.exam)
        UserManager.sharedUserManager.userRole = roleExam
        if ForceUpdateManager.sharedForceUpdateManager.checkMaintainenceFlag(){
            self.performSegue(withIdentifier: Constants.segues.profileTomaintainence, sender: self)
        }else{
            self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toLoginView{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            

        }
    }
}

