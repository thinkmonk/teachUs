//
//  LoginViewController.swift
//  TeachUs
//
//  Created by ios on 10/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginViewController: BaseViewController {

    var studentLoginView:LoginView!
    var StudentOtpView:OtpView!
    var collegeLogin:CollegeLogin!
    var username:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.addDefaultBackGroundImage()
        self.title = "Login"
        setUpLoginView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: UIColor.white)
    }
    
    func setUpLoginView(){
        
        switch UserManager.sharedUserManager.user! {
        case .Student, .Professor:
            studentLoginView = LoginView.instanceFromNib() as! LoginView
            studentLoginView.userType = UserManager.sharedUserManager.user!
            studentLoginView.setUpView()
            studentLoginView.showView(inView: self.view)
            studentLoginView.delegate = self
            break
        case .College:
            collegeLogin = CollegeLogin.instanceFromNib() as! CollegeLogin
            collegeLogin.delegate = self
            collegeLogin.setUpView()
            let manager = NetworkHandler()
            manager.url = URLConstants.CollegeURL.getCollegeList
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)

            manager.apiGet(apiName: "Get College ka list", completionHandler: { (response,code ) in
                let collegeDetails = response["collegeDetails"] as![[String:Any]]
                var collegeArray:[CollegesListModel] = []
                for college in collegeDetails{
                    let tempCollege:CollegesListModel = Mapper<CollegesListModel>().map(JSON:college)!
                    collegeArray.append(tempCollege)
                }
                self.collegeLogin.arrayCollegeList = collegeArray
                self.collegeLogin.showView(inView: self.view)
                self.collegeLogin.setUpSelectCollegeView()
                LoadingActivityHUD.hideProgressHUD()
            }, failure: { (error, code , message) in
                print(message)
                LoadingActivityHUD.hideProgressHUD()

            })
            
            break
        }
        
    }

    
    //MARK:- Keyboard delegate methods
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            if(self.studentLoginView != nil){
                if((self.studentLoginView.buttonSubmit.origin().y+self.studentLoginView.origin().y) >= (self.view.height()-keyboardSize.height) && self.view.frame.origin.y == 0)
                {
                    self.view.frame.origin.y -= keyboardSize.height/2
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
    }
}

extension LoginViewController:LoginDelegate{
    func submitDetails() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.username = self.studentLoginView.textfieldFirstName.text! + studentLoginView.textfieldSurname.text!
        UserManager.sharedUserManager.userName = self.studentLoginView.textfieldFirstName.text!
        UserManager.sharedUserManager.userMiddleName = self.studentLoginView.textfieldMiddleName.text!
        UserManager.sharedUserManager.userLastName = self.studentLoginView.textfieldSurname.text!

        let manager = NetworkHandler()
        //http://ec2-52-40-212-186.us-west-2.compute.amazonaws.com:8081/teachus/teacher/verifyTeacher?firstName=Harsh&middleName=X&surName=Gangar
        switch UserManager.sharedUserManager.user! {
        case .Professor:
            manager.url = URLConstants.TecacherURL.verifyTeacher +
            "?firstName=\(self.studentLoginView.textfieldFirstName.text!)" +
            "&middleName=\(self.studentLoginView.textfieldMiddleName.text!)" +
            "&surName=\(self.studentLoginView.textfieldSurname.text!)"
            
        case .Student:
            manager.url = URLConstants.StudentURL.verifyStudent +
                "?firstName=\(self.studentLoginView.textfieldFirstName.text!)" +
                "&middleName=\(self.studentLoginView.textfieldMiddleName.text!)" +
            "&surName=\(self.studentLoginView.textfieldSurname.text!)"
        default:
            manager.url = ""
        }
        
        
        manager.apiGetWithAnyResponse(apiName: " VERIFY USER", completionHandler: { (response, code) in
            print(response)
            LoadingActivityHUD.hideProgressHUD()
            UserManager.sharedUserManager.saveMobileNumber("\(response)")
            self.studentLoginView.hideView()
            self.setUpOtpView()

        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)

        }
        
    }
    
    func setUpOtpView(){
        StudentOtpView = OtpView.instanceFromNib() as! OtpView
        StudentOtpView.username = UserManager.sharedUserManager.userFullName
        StudentOtpView.userType = UserManager.sharedUserManager.user
        StudentOtpView.mobileNumber = UserManager.sharedUserManager.getUserMobileNumber()

        StudentOtpView.setUpSendOtpView()
        StudentOtpView.showRecordAvailableView(inView: self.view)
        StudentOtpView.delegate = self
    }
}

extension LoginViewController:OtpDelegate{
    func sendOtp() {
        //http://ec2-52-40-212-186.us-west-2.compute.amazonaws.com:8081/teachus/teacher/genOtp?firstName=Harsh&middleName=X&surName=Gangar&contactNumber=9619201282
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        
        switch UserManager.sharedUserManager.user! {
        case .Professor:
            manager.url = URLConstants.TecacherURL.generateOtp +
                "?firstName=\(self.studentLoginView.textfieldFirstName.text!)" +
                "&middleName=\(self.studentLoginView.textfieldMiddleName.text!)" +
                "&surName=\(self.studentLoginView.textfieldSurname.text!)" +
                "&contactNumber=\(UserManager.sharedUserManager.getUserMobileNumber())"

            
        case .Student:
            manager.url = URLConstants.StudentURL.generateOtp +
                "?firstName=\(self.studentLoginView.textfieldFirstName.text!)" +
                "&middleName=\(self.studentLoginView.textfieldMiddleName.text!)" +
                "&surName=\(self.studentLoginView.textfieldSurname.text!)" +
                "&contactNumber=\(UserManager.sharedUserManager.getUserMobileNumber())"

        default:
            manager.url = ""
        }
        
        
        manager.apiGetWithStringResponse(apiName: " Generate OTP", completionHandler: { (response, code) in
            print(response)
            LoadingActivityHUD.hideProgressHUD()
            self.showOtpView()

        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    func showOtpView(){
        if(self.StudentOtpView != nil){
            self.StudentOtpView.buttonSendOtp.setTitle("Resend OTP", for: UIControlState.normal)
            self.StudentOtpView.setUpOtpView()
            self.StudentOtpView.showOtpView()
        }
    }
    
    func verifyOtp() {
        let manager = NetworkHandler()
        switch UserManager.sharedUserManager.user! {
        case .Professor:
            manager.url = URLConstants.TecacherURL.validateOtp +
                "?firstName=\(self.studentLoginView.textfieldFirstName.text!)" +
                "&middleName=\(self.studentLoginView.textfieldMiddleName.text!)" +
                "&surName=\(self.studentLoginView.textfieldSurname.text!)" +
                "&contactNumber=\(UserManager.sharedUserManager.getUserMobileNumber())" +
                "&otp=\(self.StudentOtpView.textFieldOtp.text!)"
            
        case .Student:
            manager.url = URLConstants.StudentURL.validateOtp +
                "?firstName=\(self.studentLoginView.textfieldFirstName.text!)" +
                "&middleName=\(self.studentLoginView.textfieldMiddleName.text!)" +
                "&surName=\(self.studentLoginView.textfieldSurname.text!)" +
                "&contactNumber=\(UserManager.sharedUserManager.getUserMobileNumber())" +
                "&otp=\(self.StudentOtpView.textFieldOtp.text!)"

        default:
            manager.url = ""
        }
        
        manager.apiGet(apiName: " Generate OTP", completionHandler: { (response, code) in
            print(response)
            LoadingActivityHUD.hideProgressHUD()
            self.saveUser(userResponse: response)
            
            NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
        
    }
    
    func saveUser(userResponse: [String:Any]){
        switch UserManager.sharedUserManager.user! {
        case .Professor:
            UserManager.sharedUserManager.userProfilesArray.removeAll()
            let userProilfes = userResponse["profiles"] as! [String:Any]
            let profileArray = userProilfes["profile"] as! [[String:Any]]
            for user in profileArray {
                let role:String = user["role"] as! String
                if(role == "PROFESSOR"){
//                    let teacher = Mapper<TeacherProfile>().map(JSON: user)
//                    teacher?.userImage = userResponse["image"] as! String
//                    UserManager.sharedUserManager.teacherProfile = teacher
//                    UserManager.sharedUserManager.userProfilesArray.append(teacher!)

                    UserManager.sharedUserManager.saveUserImageURL(userResponse["image"] as! String)
                    UserManager.sharedUserManager.saveTeacherToDb(user)
                }
                if(role == "SUPERADMIN"){
//                    let superAdmin = Mapper<SuperAdminProfile>().map(JSON: user)
//                    UserManager.sharedUserManager.saveUserImageURL(userResponse["image"] as! String)
//                    UserManager.sharedUserManager.superAdminProfile = superAdmin
//                    UserManager.sharedUserManager.userProfilesArray.append(superAdmin!)
                
                    UserManager.sharedUserManager.saveSuperAdminToDb(user)
                }
            }
            break
            
        case .Student:
            UserManager.sharedUserManager.userProfilesArray.removeAll()
            let userProilfes = userResponse["profiles"] as! [String:Any]
            let profileArray = userProilfes["profile"] as! [[String:Any]]
            for user in profileArray {
//                let student = Mapper<StudentProfile>().map(JSON: user)
//                UserManager.sharedUserManager.studentProfile = student
//                UserManager.sharedUserManager.userProfilesArray.append(student)
                
               
                if(userResponse["image"] != nil){
                    UserManager.sharedUserManager.saveUserImageURL(userResponse["image"] as! String)
                }
                UserManager.sharedUserManager.saveStudentToDb(user)
            }
            break
        default:
            break
        }
    }
    
}

extension LoginViewController:CollegeLoginDelegate{
    func sendCollegeOtp() {
        showEnterOtpView()
    }
    
    func showEnterOtpView(){
        if(self.collegeLogin != nil){
            collegeLogin.setUpVerifyOtpView()
        }
    }
    
    func verifyCollegeOtp() {
        NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
    }
}
