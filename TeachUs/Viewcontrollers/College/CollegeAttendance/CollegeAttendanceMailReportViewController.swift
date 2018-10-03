//
//  CollegeAttendanceMailReportViewController.swift
//  TeachUs
//
//  Created by ios on 4/6/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MailReportViewControllerDelegate {
    func reportMailed()
}

class CollegeAttendanceMailReportViewController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonDismissView: UIButton!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewEmailBg: UIView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var textfieldNumber: UITextField!
    @IBOutlet weak var viewNumberBg: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewTitleBackground: UIView!
    @IBOutlet weak var ViewFormBg: UIView!
    
    @IBOutlet weak var constraintemailViewHeight: NSLayoutConstraint!
    var delegate:MailReportViewControllerDelegate!
    var collegeClass:CollegeAttendanceList!
    var verifyPasswordView:VerifyAuthPasswordView!
    var reportView:AttendanceReport!
    
    var fromDate:String = ""
    var toDate:String = ""
    //MARK:- Rx Variables
    var emailText = Variable<String>("")
    var contactNumberText = Variable<String>("")
    let disposeBag = DisposeBag()
    var isValid : Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), contactNumberText.asObservable()){ email, number in
            return email.isValidEmailAddress() && number.count == 10
        }
    }
    //MARK:- View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        NotificationCenter.default.addObserver(self, selector: #selector(CollegeAttendanceMailReportViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollegeAttendanceMailReportViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        setUpRx()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonSubmit.roundedRedButton()
//        self.viewTitleBackground.makeBottomEdgesRounded()
        self.viewEmailBg.makeEdgesRoundedWith(radius: self.viewEmailBg.height()/2)
        self.viewNumberBg.makeEdgesRoundedWith(radius: self.viewNumberBg.height()/2)
        self.labelTitle.text = " \(self.collegeClass.courseName) Report"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ViewFormBg.makeTableCellEdgesRounded()
    }
    //MARK:- Keyboard methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  {
            if self.view.frame.origin.y != 0 && (self.verifyPasswordView == nil && self.reportView == nil){
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }
    
    
    //MARK:- Outlet methods
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAuthPasswords(_ sender: Any) {
        self.sendVerificationPasswords()
    }
    
    
    //MARK:- Class methods
    
    private func setUpRx(){
        
        self.textFieldEmail.rx.text.map{ $0 ?? ""}.bind(to: self.emailText).disposed(by: disposeBag)
        self.textfieldNumber.rx.text.map { $0 ?? "" }.bind(to: self.contactNumberText).disposed(by: disposeBag)
        self.isValid.subscribe(onNext: { (isValid) in
            self.buttonSubmit.alpha = isValid ? 1 : 0
        }).disposed(by: disposeBag)
    }
    
    func sendVerificationPasswords(){
        view.endEditing(true) //remove keyboard when submit is clicked
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.sendAuthPassword
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "email":"\(self.emailText.value)",
            "contact":"\(self.contactNumberText.value)"
        ]
        
        manager.apiPost(apiName: " Get Auth Password on mobile and email", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.setUpPasswordView()
                self.ViewFormBg.removeFromSuperview()
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
        
        /*
        self.setUpPasswordView()
        self.ViewFormBg.removeFromSuperview()
        */

    }
    
    func setUpPasswordView(){
        self.verifyPasswordView = VerifyAuthPasswordView.instanceFromNib() as? VerifyAuthPasswordView
        verifyPasswordView.labelEmail.text = self.emailText.value
        verifyPasswordView.labelNumber.text = self.contactNumberText.value
        verifyPasswordView.collegeClass = self.collegeClass
        
        verifyPasswordView.setUpUI()
        verifyPasswordView.showView(inView: self.view)
        verifyPasswordView.delegate = self
    }
    
    
    func setUpReportView(){
        self.reportView = AttendanceReport.instanceFromNib() as? AttendanceReport
        reportView.collegeClass = self.collegeClass
        reportView.setUpUI()
        reportView.showView(inView: self.view)
        reportView.delegate = self
    }

}
//MARK:- Verify auth password protocol
extension CollegeAttendanceMailReportViewController:VerifyAuthPasswordProtocol{
    func dismissView() {
        self.dismissView(self)
    }
    
    func verifypassword(numberOtp: String, emailOTP: String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.verifyauthPassword
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "email":"\(self.emailText.value)",
            "contact":"\(self.contactNumberText.value)",
//            "email_password":"\(emailOTP)",
            "contact_password": "\(numberOtp)",
            "class_id":"\(self.collegeClass.classId)",
            "from_date":"\(self.fromDate)",
            "to_date":"\(self.toDate)"
            ]
        
        manager.apiPost(apiName: " Verify Auth Password on mobile and email", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.verifyPasswordView.hideView()
                self.setUpReportView()
            }
            else{
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
        /*
        self.verifyPasswordView.hideView()
        self.setUpReportView()
 */

    }
}

//MARK:- Attendace Report Protocol

extension CollegeAttendanceMailReportViewController:AttendanceReportProtocol{
    func dissmissView() {
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate.reportMailed()
            }
        }
    }
    
    func sendReport(type: ReportType) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        
        switch type {
        case .mailStudents:
            manager.url = URLConstants.CollegeURL.sendEmailToStudents
            break
            
        case .smsStudents:
            manager.url = URLConstants.CollegeURL.sendSmsToStudents
            break
        }
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "class_id":"\(self.collegeClass.classId)",
            "from_date":"\(self.fromDate)",
            "to_date":"\(self.toDate)"
        ]
        
        manager.apiPost(apiName: " send sms/mail to students", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                switch type {
                case .mailStudents:
                    self.reportView.animationFotMailSuccess(message: message)
                    self.reportView.showDissmissButton()
                    break
                    
                case .smsStudents:
                    self.reportView.animationForSmsSuccess(message: message)
                    break
                }
                
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
        
    }
    
    
}
