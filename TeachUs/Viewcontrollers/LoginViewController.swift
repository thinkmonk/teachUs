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
    var otpTime:Int = 180
    var otpTimeUpdated:Int!
    var otpTimer:Timer!
    
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
            studentLoginView = (LoginView.instanceFromNib() as! LoginView)
            studentLoginView.userType = UserManager.sharedUserManager.user!
            studentLoginView.setUpView()
            studentLoginView.showView(inView: self.view)
            studentLoginView.delegate = self
            break
        case .College:
            collegeLogin = (CollegeLogin.instanceFromNib() as! CollegeLogin)
            collegeLogin.delegate = self
            collegeLogin.setUpView()
            self.collegeLogin.showView(inView: self.view, yPosition: (self.statusBarHeight+self.navBarHeight+20))
            /*
            let manager = NetworkHandler()
            manager.url = URLConstants.CollegeURL.getCollegeList
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            manager.apiGet(apiName: "Get College ka list", completionHandler: { (response,code ) in
                let collegeDetails = response["college_list"] as![[String:Any]]
                var collegeArray:[CollegesListModel] = []
                for college in collegeDetails{
                    let tempCollege:CollegesListModel = Mapper<CollegesListModel>().map(JSON:college)!
                    collegeArray.append(tempCollege)
                }
                self.collegeLogin.arrayCollegeList = collegeArray
                self.collegeLogin.setUpSelectCollegeView()
                self.collegeLogin.showView(inView: self.view, yPosition: (self.statusBarHeight+self.navBarHeight+20))
                LoadingActivityHUD.hideProgressHUD()
            }, failure: { (error, code , message) in
                print(message)
                LoadingActivityHUD.hideProgressHUD()

            })*/
            
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
//MARK:- Login Delegate

extension LoginViewController:LoginDelegate{
    func submitDetails() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.username = self.studentLoginView.textfieldFirstName.text! + studentLoginView.textfieldSurname.text!
        UserManager.sharedUserManager.userName = self.studentLoginView.textfieldFirstName.text!
        UserManager.sharedUserManager.userLastName = self.studentLoginView.textfieldSurname.text!
        UserManager.sharedUserManager.userEmail = self.studentLoginView.textFieldEmailId.text!

        
        let manager = NetworkHandler()
        
        let parameters:[String:Any] = ["email":UserManager.sharedUserManager.userEmail,
                                       "role_id":"\(UserManager.sharedUserManager.userRole.roleId)"
                                        ]
        manager.url = URLConstants.Login.checkDetails
        
        manager.apiPost(apiName: " VERIFY USER", parameters:parameters, completionHandler: { (result, code, response) in
            print(response)
            LoadingActivityHUD.hideProgressHUD()
            
            if (code == 200){
                let contactString:String = response["contact"] as! String
                let firstName:String = response["f_name"] as! String
                let lastName:String = response["l_name"] as! String

                UserManager.sharedUserManager.saveMobileNumber(contactString)
                UserManager.sharedUserManager.userName = firstName
                UserManager.sharedUserManager.userLastName = lastName
                self.studentLoginView.hideView()
                self.setUpOtpView()
            }
            else{
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            print(message)
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
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
        self.sendOtp()
    }
}
//MARK:- OTP Delegate

extension LoginViewController:OtpDelegate{
    func sendOtp() {
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()

        manager.url = URLConstants.Login.sendOtp
        let parameters:[String:Any] =
            [
                "email":"\(UserManager.sharedUserManager.userEmail)",
                "role_id":"\(UserManager.sharedUserManager.userRole.roleId)",
                "contact":"\(UserManager.sharedUserManager.getUserMobileNumber())"
        ]
        
        manager.apiPost(apiName: "Generate OTP", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.showOtpView()
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    func showOtpView(){
        
        if(self.StudentOtpView != nil){
            otpTimeUpdated = otpTime
            GlobalFunction.minutesAndSecsFrom(seconds: otpTimeUpdated) { (mins, secs) in
                let minutes = GlobalFunction.getStringFrom(seconds: mins)
                let seconds = GlobalFunction.getStringFrom(seconds: secs)
                self.StudentOtpView.labelOtpTimeLeft.text = "Resend OTP \(minutes):\(seconds)  "
            }
            self.StudentOtpView.buttonSendOtp.isHidden = true
            self.StudentOtpView.buttonSendOtp.isEnabled = false
            self.StudentOtpView.labelOtpTimeLeft.isHidden = false
            self.StudentOtpView.labelOtpTimeLeft.backgroundColor = UIColor.lightGray
            otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.enableButton), userInfo: nil, repeats: true)

            self.StudentOtpView.setUpOtpView()
            self.StudentOtpView.showOtpView()
        }
    }
    
    @objc func enableButton(){
        otpTimeUpdated -= 1
        GlobalFunction.minutesAndSecsFrom(seconds: otpTimeUpdated) { (mins, secs) in
            let minutes = GlobalFunction.getStringFrom(seconds: mins)
            let seconds = GlobalFunction.getStringFrom(seconds: secs)
            self.StudentOtpView.labelOtpTimeLeft.text = "Resend OTP \(minutes):\(seconds)  "
        }
        if(Int(otpTimeUpdated) == 0){
            self.StudentOtpView.labelOtpTimeLeft.isHidden = true
            self.StudentOtpView.buttonSendOtp.isHidden = false
            self.StudentOtpView.buttonSendOtp.backgroundColor = Constants.colors.themeBlue
            self.StudentOtpView.buttonSendOtp.isEnabled = true
            self.StudentOtpView.buttonSendOtp.setTitle("Resend OTP", for: UIControlState.normal)
            otpTimer.invalidate()
        }
    }
    
    func verifyOtp() {
        let manager = NetworkHandler()
        StudentOtpView.textFieldOtp.resignFirstResponder()
        manager.url = URLConstants.Login.verifyOtp
        let parameters:[String:Any] =
            [
                "email":"\(UserManager.sharedUserManager.userEmail)",
                "role_id":"\(UserManager.sharedUserManager.userRole.roleId)",
                "contact":"\(UserManager.sharedUserManager.getUserMobileNumber())",
                "otp":"\(self.StudentOtpView.textFieldOtp.text!)"
        ]
        manager.apiPost(apiName: "Verify OTP", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.otpTimer.invalidate()
            if(code == 200){
                let accessToken:String = response["token"] as! String
                UserManager.sharedUserManager.setAccessToken(accessToken)
                self.getAndSaveUserToDb(true)
            }
            else{
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            self.otpTimer.invalidate()
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
}
//MARK:- College Login Delegate
extension LoginViewController:CollegeLoginDelegate{
    func sendCollegeOtp(mobileNumber:String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        
        manager.url = URLConstants.Login.sendOtp
        let parameters:[String:Any] =
            [
                "role_id":"\(UserManager.sharedUserManager.userRole.roleId)",
                "contact":"\(mobileNumber)"
        ]
        UserManager.sharedUserManager.saveMobileNumber(mobileNumber)
        manager.apiPost(apiName: "Generate OTP", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if (code == 200){
                self.showEnterOtpView()
            }else{
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    func showEnterOtpView(){
        if(self.collegeLogin != nil){
            collegeLogin.setUpVerifyOtpView()
            collegeLogin.textFieldOtp.becomeFirstResponder()
            otpTimeUpdated = otpTime
            GlobalFunction.minutesAndSecsFrom(seconds: otpTimeUpdated) { (mins, secs) in
                let minutes = GlobalFunction.getStringFrom(seconds: mins)
                let seconds = GlobalFunction.getStringFrom(seconds: secs)
                self.collegeLogin.labelOtpTimeLeft.text = "Resend OTP \(minutes):\(seconds)  "
            }
            self.collegeLogin.buttonSendOtp.isHidden = true
            self.collegeLogin.buttonSendOtp.isEnabled = false
            self.collegeLogin.labelOtpTimeLeft.isHidden = false
            self.collegeLogin.labelOtpTimeLeft.backgroundColor = UIColor.lightGray
            otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.enableCollegeResendOtpButton), userInfo: nil, repeats: true)

        }
    }
    
    @objc func enableCollegeResendOtpButton(){
        otpTimeUpdated -= 1
        GlobalFunction.minutesAndSecsFrom(seconds: otpTimeUpdated) { (mins, secs) in
            let minutes = GlobalFunction.getStringFrom(seconds: mins)
            let seconds = GlobalFunction.getStringFrom(seconds: secs)
            self.collegeLogin.labelOtpTimeLeft.text = "Resend OTP \(minutes):\(seconds)  "
        }
        if(Int(otpTimeUpdated) == 0){
            self.collegeLogin.labelOtpTimeLeft.isHidden = true
            self.collegeLogin.buttonSendOtp.isHidden = false
            self.collegeLogin.buttonSendOtp.backgroundColor = Constants.colors.themeBlue
            self.collegeLogin.buttonSendOtp.isEnabled = true
            self.collegeLogin.buttonSendOtp.setTitle("Resend OTP", for: UIControlState.normal)
            otpTimer.invalidate()
        }
    }
    
    func verifyCollegeOtp() {
        let manager = NetworkHandler()
        collegeLogin.textFieldOtp.resignFirstResponder()
        manager.url = URLConstants.Login.verifyOtp
        let parameters:[String:Any] =
            [
                "role_id":"\(UserManager.sharedUserManager.userRole.roleId)",
                "contact":"\(UserManager.sharedUserManager.getUserMobileNumber())",
                "otp":"\(self.collegeLogin.textFieldOtp.text!)"
        ]
        manager.apiPost(apiName: "Verify OTP", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.otpTimer.invalidate()
            if(code == 200){
                let accessToken:String = response["token"] as! String
                UserManager.sharedUserManager.setAccessToken(accessToken)
                self.getAndSaveUserCollegeDetails()
            }else{
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            self.otpTimer.invalidate()
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
}
