//
//  CollegeAttendanceListViewController.swift
//  TeachUs
//
//  Created by ios on 3/18/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper

class CollegeAttendanceListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[CollegeAttendanceList]? = []
    @IBOutlet weak var tableViewCollegeAttendanceList: UITableView!
    @IBOutlet weak var layoutReportViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var buttonFromDate: UIButton!
    @IBOutlet weak var labelToDate: UILabel!
    @IBOutlet weak var buttonToDate: UIButton!
    @IBOutlet weak var labelClass: UILabel!    
    @IBOutlet weak var buttonSelectClass: UIButton!
    @IBOutlet weak var buttonClassDropDown: UIButton!
    @IBOutlet weak var labelCriteria: UILabel!
    @IBOutlet weak var buttonSelectCriteria: UIButton!
    @IBOutlet weak var buttonCriteriaDropDown: UIButton!
    @IBOutlet weak var buttonMailReport: UIButton!
    @IBOutlet weak var viewMailReportBg: UIView!
    @IBOutlet weak var viewCriteriaBg: UIView!
    
    var viewClassList : ViewClassSelection!
    var viewEmailId : VerifyEmail!

    var toDate:Date!
    var fromDate:Date!
    var fromDatePicker: ViewDatePicker!
    let criteriaDropDown = DropDown()
    var activeLabel:UILabel!
    var selectedCriteria:String = ""
    var isMailReportVisible:Bool = false
    var arrayCriteriaList:[String] = ["All",
                                      "Below 25",
                                      "Below 30",
                                      "Below 40",
                                      "Below 50",
                                      "Below 60",
                                      "Below 70",
                                      "Below 75"]
    var arrayCriteriaNumber:[Int] = [0, 25, 30, 40, 50, 60, 70, 75]
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MMM-dd"
        return df
    }
    
    var bottomViewHeight:CGFloat {
        return self.buttonMailReport.height() + self.viewMailReportBg.height()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewCollegeAttendanceList.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        self.tableViewCollegeAttendanceList.delegate = self
        self.tableViewCollegeAttendanceList.dataSource = self
        self.tableViewCollegeAttendanceList.alpha = 0.0
        self.tableViewCollegeAttendanceList.addSubview(refreshControl)
        self.showMailView(value: false)
        self.buttonMailReport.isHidden = true
        self.getClassAttendance()
        self.initDatePicker()
        self.addTapGestures()
        self.setUpCriteriaDropDown()
        self.initEmailIdView()
        NotificationCenter.default.addObserver(self, selector: #selector(CollegeAttendanceListViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollegeAttendanceListViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Custom Methods
    override func refresh(sender: AnyObject) {
        self.getClassAttendance()
        super.refresh(sender: sender)
    }
    
    func showMailView(value:Bool? = false){
        self.viewMailReportBg.isHidden = !value!
        self.isMailReportVisible = value!
        if(value!){
            self.tableViewCollegeAttendanceList.contentInset = UIEdgeInsetsMake(0, 0, self.bottomViewHeight, 0);
        }else{
            self.tableViewCollegeAttendanceList.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    
    func getClassAttendance(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classAttendanceList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: " Get class attendance", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let attendanceListArray = response["class_attendance_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource?.removeAll()
            for attendancelist in attendanceListArray{
                let tempList = Mapper<CollegeAttendanceList>().map(JSONObject: attendancelist)
                self.arrayDataSource?.append(tempList!)
            }
            self.arrayDataSource?.sort(by: { ($0.year, $0.courseCode, $0.classDivision) < ($1.year, $1.courseCode, $1.classDivision) })
            self.initClassSelectionView()
            
            self.tableViewCollegeAttendanceList.reloadData()
            self.showTableView()
            #warning ("This is a temp change, until reports are live")
            self.buttonMailReport.isHidden = true
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func initClassSelectionView(){
        self.viewClassList = ViewClassSelection.instanceFromNib() as? ViewClassSelection
        self.viewClassList.delegate = self
        
        //init class selection list after sorting
        for college in self.arrayDataSource!{
            let selectedCollegeList = SelectCollegeClass(college, true)
            CollegeClassManager.sharedManager.selectedClassArray.append(selectedCollegeList)
        }
    }
    
    func initEmailIdView(){
        self.viewEmailId = VerifyEmail.instanceFromNib() as? VerifyEmail
        self.viewEmailId.delegate = self
    }
    
    func showTableView(){
        self.tableViewCollegeAttendanceList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewCollegeAttendanceList.alpha = 1.0
            self.tableViewCollegeAttendanceList.transform = CGAffineTransform.identity
        }
    }
    
    func initDatePicker(){
        if(fromDatePicker == nil){
            fromDatePicker = ViewDatePicker.instanceFromNib() as? ViewDatePicker
            fromDatePicker.setUpPicker(type: .date)
            fromDatePicker.buttonOk.addTarget(self, action: #selector(CollegeAttendanceListViewController.dismissDatePicker), for: .touchUpInside)
            fromDatePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
            fromDatePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
            self.toDate = Date()
            self.labelToDate.text  = self.dateFormatter.string(from: self.toDate!)
            self.fromDate = NSCalendar.current.date(byAdding: .month, value: -1, to: Date())
            self.labelFromDate.text = self.dateFormatter.string(from: self.fromDate!)
        }
    }
    
    @objc func dismissDatePicker(){
        if(fromDatePicker != nil){
            fromDatePicker.alpha = 0
            fromDatePicker.removeFromSuperview()
        }
        self.activeLabel.text = self.dateFormatter.string(from: self.fromDatePicker.picker.date)
        switch activeLabel.tag {
        case 100:
            fromDate = fromDatePicker.picker.date
            
        case 101:
            toDate = fromDatePicker.picker.date
            
        default:
            return
        }
    }
    
    func addTapGestures(){
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceListViewController.showDatePicker(_:)))
        self.labelFromDate.isUserInteractionEnabled = true
        self.labelFromDate.addGestureRecognizer(dateTap)
        
        let dateToTap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceListViewController.showDatePicker(_:)))
        self.labelToDate.isUserInteractionEnabled = true
        self.labelToDate.addGestureRecognizer(dateToTap)
        
        let criteriaTap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceListViewController.showCriteriaDropdown(_:)))
        self.labelCriteria.isUserInteractionEnabled = true
        self.labelCriteria.addGestureRecognizer(criteriaTap)
    }
    
    func setUpCriteriaDropDown(){
        self.criteriaDropDown.anchorView = self.buttonSelectCriteria
        self.criteriaDropDown.bottomOffset = CGPoint(x: 0, y: buttonSelectCriteria.height())
        self.criteriaDropDown.width = self.viewCriteriaBg.width()
        
        for criteria in arrayCriteriaList{
            self.criteriaDropDown.dataSource.append(criteria)
        }
        self.criteriaDropDown.selectionAction = { [unowned self] (index, item) in
            self.selectedCriteria = self.arrayCriteriaList[index]
            CollegeClassManager.sharedManager.selectedAttendanceCriteria = self.arrayCriteriaNumber[index]
            let criteriaText = "\(self.arrayCriteriaList[index])"
            self.buttonSelectCriteria.setTitle(criteriaText, for: .normal)
        }
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
            self.viewEmailId.viewBg.frame.origin.y += keyboardSize.height/2
        }
    }
    
    //MARK:- Outlet Methods
    @IBAction func showDatePicker(_ sender: Any){
        if let senderTap:UITapGestureRecognizer = sender as? UITapGestureRecognizer{
            self.activeLabel = senderTap.view as? UILabel
        }
        
        if let senderButton:UIButton = sender as? UIButton{
            switch senderButton.tag{
            case 100:
                self.activeLabel = self.labelFromDate!
                
            case 101:
                self.activeLabel = self.labelToDate!
            default:
                break
            }
        }
        self.fromDatePicker.showView(inView: self.view)
    }

    @IBAction func showCriteriaDropdown(_ sender: Any) {
        self.criteriaDropDown.show()
    }
    
    @IBAction func showClassList(_ sender: Any) {
        self.viewClassList.frame = self.view.frame
        self.view.addSubview(self.viewClassList)
    }
    
    @IBAction func mailReport(_ sender: Any) {
        if(!self.isMailReportVisible){
            self.showMailView(value: true)
        }else{
            self.showEmailView()
        }
    }
    func showEmailView(){
        self.viewEmailId.frame = self.view.frame
//        self.viewEmailId.center = UIApplication.shared.keyWindow?.center ?? self.view.center
        self.view.addSubview(self.viewEmailId)
    }
}

extension  CollegeAttendanceListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.arrayDataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewCollegeAttendanceList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //***have reused the syllabus-details cell***

        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath) as! SyllabusStatusTableViewCell
        cell.labelSubject.text = "\(self.arrayDataSource![indexPath.section].courseName) - \(self.arrayDataSource![indexPath.section].classDivision)"
        cell.labelNumberOfLectures.text =  "\(self.arrayDataSource![indexPath.section].totalStudents)"
        cell.labelAttendancePercent.text = "\(self.arrayDataSource![indexPath.section].avgStudents)"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segues.toCollegeAttendanceDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toCollegeAttendanceDetail {
            let destinationVC:CollegeAttendanceDetailsViewController = segue.destination as! CollegeAttendanceDetailsViewController
            destinationVC.collegeClass = self.arrayDataSource![(self.tableViewCollegeAttendanceList.indexPathForSelectedRow?.section)!]
        }
    }
}

extension CollegeAttendanceListViewController:ViewClassSelectionDelegate{
    func classViewDismissed() {
        self.viewClassList.removeFromSuperview()
        print("class dismissed")
    }
}

extension CollegeAttendanceListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance (Reports)")
    }
}

extension CollegeAttendanceListViewController:verifyEmailDelegae{
    func otpSubmitted() {
        //this methos is not required as we are only taking email to export attendance report
        
    }
    
    func emailSubmitted() {
        self.viewEmailId.removeFromSuperview()
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.verifyauthPassword
        let urlDateFormatter = DateFormatter()
        urlDateFormatter.dateFormat = "YYYY-MM-dd"
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "email":"\(CollegeClassManager.sharedManager.email.value)",
            "class_id":"\(CollegeClassManager.sharedManager.getSelectedClassList)",
            "criteria":"\(CollegeClassManager.sharedManager.selectedAttendanceCriteria ?? 0)"
        ]
        
        if(self.fromDate != nil)
        {
            parameters["from_date"] = urlDateFormatter.string(from: self.fromDate)
        }
        
        if(self.toDate != nil)
        {
            parameters["to_date"] = urlDateFormatter.string(from: self.toDate)
        }
        
        manager.apiPost(apiName: " Send Class report to email", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.showMailView(value: false)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
}
