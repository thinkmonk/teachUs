//
//  CollegeClassRatingListViewController.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper


class CollegeClassRatingListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[RatingClassList] = []
    @IBOutlet weak var tableViewClassList: UITableView!
    @IBOutlet weak var buttonMailReport: UIButton!
    var viewEmailId : VerifyEmail!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewClassList.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        self.tableViewClassList.delegate = self
        self.tableViewClassList.dataSource = self
        self.tableViewClassList.alpha = 0.0
        self.tableViewClassList.addSubview(refreshControl)
        self.initEmailIdView()
        NotificationCenter.default.addObserver(self, selector: #selector(CollegeAttendanceListViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollegeAttendanceListViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.initEmailIdView()
        self.getClassRating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresh(sender: AnyObject) {
        self.getClassRating()
        super.refresh(sender: sender)
    }
    //MARK:- Outlet methods
    
    @IBAction func actionMailFeedback(_ sender: Any) {
        self.showEmailView()
    }
    
    //MARK:- Keyboard show/hide notification.
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            if((self.viewEmailId.viewBg.origin().y+self.viewEmailId.viewBg.height()) >= (self.viewEmailId.height()-keyboardSize.height) )
            {
                self.viewEmailId.viewBg.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            self.viewEmailId.viewBg.center = self.view.center
        }
    }
    
    //MARK:- Class methods
    
    func initEmailIdView(){
        self.viewEmailId = VerifyEmail.instanceFromNib() as? VerifyEmail
        self.viewEmailId.delegate = self
    }
    
    func showEmailView(){
        self.viewEmailId.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width(), height: self.view.height())
        self.view.addSubview(self.viewEmailId)
    }
    
    func showOtpView(){
        self.viewEmailId.buttonOtp.setTitle("Export Feedback", for: .normal)
        self.viewEmailId.viewVerifyOtpbg.alpha = 1
        self.viewEmailId.layoutVerifyOtpHeight.constant = 100
    }
    
    func getClassRating(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classRatingList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)"
        ]
        
        manager.apiPost(apiName: " Get class attendance", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let ratingListArray = response["class_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for ratingList in ratingListArray{
                let tempList = Mapper<RatingClassList>().map(JSONObject: ratingList)
                self.arrayDataSource.append(tempList!)
            }
            self.arrayDataSource.sort(by: { ($0.courseName, $0.classDivision) < ($1.courseName, $1.classDivision) })
            self.tableViewClassList.reloadData()
            self.showTableView()
            
            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func sendOtpToVerifyEmail(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.sendAuthPassword
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "email":"\(self.viewEmailId.textfieldEmail.text!)",
            "contact":"\(UserManager.sharedUserManager.getUserMobileNumber)"
        ]
        
        manager.apiPost(apiName: "Send Email OTP for feedback", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.showOtpView()
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func verifyOtpAndExportReport(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.verifyFeedbackAuthPassword
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "email":"\(self.viewEmailId.textfieldEmail.text ?? "")",
            "contact":"\(UserManager.sharedUserManager.getUserMobileNumber())",
            "contact_password":"\(self.viewEmailId.textFieldOtp.text ?? "")"
        ]
        
        manager.apiPost(apiName: "Verify OTP and export report", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.viewEmailId.removeFromSuperview()
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableViewClassList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewClassList.alpha = 1.0
            self.tableViewClassList.transform = CGAffineTransform.identity
        }
    }

}

extension CollegeClassRatingListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath) as! SyllabusStatusTableViewCell
        cell.labelSubject.text = "\(self.arrayDataSource[indexPath.section].courseName) - \(self.arrayDataSource[indexPath.section].classDivision)"
        cell.labelNumberOfLectures.text = "\(self.arrayDataSource[indexPath.section].totalRate)"
        cell.labelAttendancePercent.text  = "\(self.arrayDataSource[indexPath.section].averageRating)"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewClassList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segues.toProfessorRatingList, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toProfessorRatingList{
            let destinationVC:CollegeTeachersRatingListViewController = segue.destination as! CollegeTeachersRatingListViewController
            destinationVC.arrayClassList = self.arrayDataSource
            destinationVC.selectedIndex = (self.tableViewClassList.indexPathForSelectedRow?.section)!
            destinationVC.ratingClass = self.arrayDataSource[(self.tableViewClassList.indexPathForSelectedRow?.section)!]
        }
    }
}



extension CollegeClassRatingListViewController:verifyEmailDelegae
{
    func emailSubmitted() {
        self.sendOtpToVerifyEmail()
    }
    
    func otpSubmitted() {
        self.verifyOtpAndExportReport()
    }
    
    
}

extension CollegeClassRatingListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Ratings")
    }
}
