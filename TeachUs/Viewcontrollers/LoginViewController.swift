//
//  LoginViewController.swift
//  TeachUs
//
//  Created by ios on 10/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    var studentLoginView:LoginView!
    var StudentOtpView:OtpView!
    var username:String = ""
    
    var usertype:LoginUserType!
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
        
        switch usertype! {
        case .Student, .Professor:
            studentLoginView = LoginView.instanceFromNib() as! LoginView
            studentLoginView.userType = self.usertype
            studentLoginView.setUpView()
            studentLoginView.showView(inView: self.view)
            studentLoginView.delegate = self
        default:
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
        self.username = self.studentLoginView.textfieldFirstName.text! + studentLoginView.textfieldSurname.text!
        self.studentLoginView.hideView()
        self.setUpOtpView()
    }
    
    func setUpOtpView(){
        StudentOtpView = OtpView.instanceFromNib() as! OtpView
        StudentOtpView.username = self.username
        StudentOtpView.mobileNumber = "+919619201282 isko set kar"
        StudentOtpView.userType = self.usertype
        StudentOtpView.setUpSendOtpView()
        StudentOtpView.showRecordAvailableView(inView: self.view)
        StudentOtpView.delegate = self
    }
}

extension LoginViewController:OtpDelegate{
    func sendOtp() {
        self.showOtpView()
    }
    
    func showOtpView(){
        if(self.StudentOtpView != nil){
            self.StudentOtpView.buttonSendOtp.setTitle("Resend OTP", for: UIControlState.normal)
            self.StudentOtpView.setUpOtpView()
            self.StudentOtpView.showOtpView()
        }
    }
    
    func verifyOtp() {
        
    }
}
