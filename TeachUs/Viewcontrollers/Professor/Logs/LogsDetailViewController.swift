//
//  LogsDetailViewController.swift
//  TeachUs
//
//  Created by ios on 11/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class LogDetailSyllabus {
    var unitName:String = ""
    var unitNumber:String = ""
    var chapter:Chapter!
}


class LogsDetailViewController: BaseViewController {
    
    var logClass:LogsClassList!
    var arrayDataSource:[ProfessorLogsDataSource]! = []
    var arrayLogsDetails:[LogDetails] = []
    var selectedCollege:College!
    var selectedIndex:Int = 0
    var allCollegeArray:[College] = []
    var calenderView: ViewLogsCalender? // declare variable inside your controller
    
    //for collegeLogs Details
    var isCollegeLogsSubjectData:Bool = false //for college logs
    var allCollegeSubjects = [SubjectsDetail]()
    var professorId: String?
    
    @IBOutlet weak var tableLogsDetail: UITableView!
    @IBOutlet weak var buttonPreviousSubject: UIButton!
    @IBOutlet weak var buttonNextSubject: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCalenderView()
        self.tableLogsDetail.backgroundColor = UIColor.clear
        self.tableLogsDetail.delegate = self
        self.tableLogsDetail.dataSource = self
        self.tableLogsDetail.separatorStyle = .none
        self.tableLogsDetail.alpha = 0
    
        self.tableLogsDetail.register(UINib(nibName: "LogsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId)
        self.tableLogsDetail.register(UINib(nibName: "SyllabusDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId)
        
        var image = UIImage(named:Constants.Images.calendarWhite)
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(LogsDetailViewController.showCalenderView))
        self.setUpButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isCollegeLogsSubjectData{
                self.getCollgeProfessorLogDetails(fromDate: self.calenderView?.fromDateString ?? "", toDate: self.calenderView?.toDateStirng ?? "")
            }else{
                self.getLogs(fromDate: self.calenderView?.fromDateString ?? "", toDate: self.calenderView?.toDateStirng ?? "")
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLogDetails(fromDate:String, toDate:String){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.logDetails
        var parameters = [String:Any]()
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        parameters["subject_id"] = self.allCollegeArray[selectedIndex].subjectId
        parameters["class_id"] = self.allCollegeArray[selectedIndex].classId
        if(fromDate != "" && toDate != ""){
            parameters["from_date"] = fromDate
            parameters["to_date"] =  toDate
        }
        
        manager.apiPost(apiName: "Get professor logs details", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.arrayLogsDetails.removeAll()
            self.title = self.allCollegeArray[self.selectedIndex].subjectName
            
            guard let logs = response["subject_logs"] as? [[String:Any]] else{
                self.arrayDataSource.removeAll()
                self.tableLogsDetail.reloadData()
                return
            }
            if logs.count == 0{
                self.arrayDataSource.removeAll()
                self.tableLogsDetail.reloadData()
                return
            }
            for log in logs{
                let tempLog = Mapper<LogDetails>().map(JSON: log)
                //remove all the empty values coming in the logs.
                if(tempLog?.dateOfSubmission != " " && (tempLog?.unitArray.count)! >= 1){
                    self.arrayLogsDetails.append(tempLog!)
                }
            }
            
            self.arrayLogsDetails.sort(by: { ($0.lectureDate.convertToDate()!) < ($1.lectureDate.convertToDate()!) })
            self.makeDataSource()
            self.showTableView()
        }) { (success, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlertWithTitle(nil, alertMessage: message)
            print(message)
        }
    }
    
    
    func getCollgeProfessorLogDetails(fromDate:String, toDate:String){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getcollegeSubjectLogsDetals
        var parameters = [String:Any]()
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        parameters["subject_id"] =  self.allCollegeSubjects[self.selectedIndex].subjectID
        parameters["class_id"] =  self.allCollegeSubjects[self.selectedIndex].classID
        parameters["professor_id"] = self.professorId ?? ""

        if(fromDate != "" && toDate != ""){
            parameters["from_date"] = fromDate
            parameters["to_date"] =  toDate
        }
        
        manager.apiPost(apiName: "Get college professor logs details", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.arrayLogsDetails.removeAll()
            self.title = self.allCollegeSubjects[self.selectedIndex].subjectName
            
            guard let logs = response["subject_logs"] as? [[String:Any]] else{
                self.arrayDataSource.removeAll()
                self.tableLogsDetail.reloadData()
                return
            }
            if logs.count == 0{
                self.arrayDataSource.removeAll()
                self.tableLogsDetail.reloadData()
                return
            }
            for log in logs{
                let tempLog = Mapper<LogDetails>().map(JSON: log)
                //remove all the empty values coming in the logs.
                if(tempLog?.dateOfSubmission != " " && (tempLog?.unitArray.count)! >= 1){
                    self.arrayLogsDetails.append(tempLog!)
                }
            }
            
            self.arrayLogsDetails.sort(by: { ($0.lectureDate.convertToDate()!) > ($1.lectureDate.convertToDate()!) })
            self.makeDataSource()
            self.showTableView()
        }) { (success, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlertWithTitle(nil, alertMessage: message)
            print(message)
        }
    }
    
    func initCalenderView(){
        calenderView = Bundle.main.loadNibNamed("ViewLogsCalender", owner: self, options: nil)?.first as? ViewLogsCalender
        calenderView?.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width(), height: self.view.height())
        calenderView?.delegate = self
    }
    
    @objc func showCalenderView(){
        self.view.addSubview(calenderView!)
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
//        let detailsDataSource = ProfessorLogsDataSource(celType: .LogDetails, attachedObject: nil)
//        self.arrayDataSource.append(detailsDataSource)
        
        for log in self.arrayLogsDetails{
            let detailsDataSource = ProfessorLogsDataSource(celType: .LogDetails, attachedObject: log)
            self.arrayDataSource.append(detailsDataSource)
            
            for unit in log.unitArray{
                for chapter in unit.topicArray!{
                    let attachedSyllabus = LogDetailSyllabus()
                    attachedSyllabus.unitName = unit.unitName ?? ""
                    attachedSyllabus.unitNumber = unit.unitNumber ?? ""
                    attachedSyllabus.chapter = chapter
                    let syllabusDatasource = ProfessorLogsDataSource(celType: .SyllabusDetail, attachedObject: attachedSyllabus)
                    self.arrayDataSource.append(syllabusDatasource)
                }
            }
        }
        //        self.showTableView()
        self.tableLogsDetail.reloadData()
    }
    
    func showTableView(){
        self.tableLogsDetail.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableLogsDetail.alpha = 1.0
            self.tableLogsDetail.transform = CGAffineTransform.identity
        }
    }
    
    func setUpButtons(){
        if  self.selectedIndex == 0 {
            buttonPreviousSubject.isEnabled = false
            self.buttonNextSubject.isEnabled = true
        }else if (self.selectedIndex == self.allCollegeArray.count-1)  || (self.selectedIndex == self.allCollegeSubjects.count-1) {
            buttonPreviousSubject.isEnabled = true
            self.buttonNextSubject.isEnabled = false
        }else{
            self.buttonNextSubject.isEnabled = true
            self.buttonPreviousSubject.isEnabled = true
        }
    }
    
    @IBAction func showLogsForNextSubject(_ sender: Any) {
        if self.isCollegeLogsSubjectData{
            if (self.selectedIndex < self.allCollegeSubjects.count-1){
                self.selectedIndex += 1
                self.getCollgeProfessorLogDetails(fromDate: self.calenderView?.fromDateString ?? "", toDate: self.calenderView?.toDateStirng ?? "")
                self.setUpButtons()
            }
        }else{
            if (self.selectedIndex < self.allCollegeArray.count-1){
                self.selectedIndex += 1
                self.getLogs(fromDate: "", toDate: "")
                self.setUpButtons()
            }
        }
    }
    
    @IBAction func showLogsForPreviousSubject(_ sender: Any) {
        if self.isCollegeLogsSubjectData{
            if (self.selectedIndex > 0){
                self.selectedIndex -= 1
                self.getCollgeProfessorLogDetails(fromDate: self.calenderView?.fromDateString ?? "", toDate: self.calenderView?.toDateStirng ?? "")
                self.setUpButtons()
            }
        }else{
            if (self.selectedIndex > 0){
                self.selectedIndex -= 1
                self.getLogs(fromDate: "", toDate: "")
                self.setUpButtons()
            }
        }
    }
    
}

extension LogsDetailViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayDataSource[indexPath.row]
        switch cellDataSource.logsCellType! {
        case .LogDetails:
            let cell:LogsDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId, for: indexPath) as! LogsDetailTableViewCell
            let logs:LogDetails = cellDataSource.attachedObject as! LogDetails
            cell.labelNumberOfLecs.text = logs.numberOfLecture
            cell.labelAttendanceCount.text = logs.totalStudentAttendance
            cell.labelLectureTime.text = "\(logs.fromTime) to \(logs.toTime)"
            cell.viewTimeOfSubject.alpha = 1
            //            let datstring = logs.dateOfSubmission.getDateFromString()
            cell.labelDate.text = "\(logs.lectureDate)"
            cell.labelTimeOfSubmission.text = "\(logs.dateOfSubmission)"
            cell.selectionStyle = .none
            cell.buttonEditAttendance.indexPath = indexPath
            cell.buttonDelete.indexPath = indexPath
            cell.buttonEditAttendance.isHidden = self.isCollegeLogsSubjectData //edit option not available for college logs
            cell.buttonDelete.isHidden = self.isCollegeLogsSubjectData //delete option not available for college logs
            cell.delegate = self
            return cell
            
        case .SyllabusDetail:
            let cell:SyllabusDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId, for: indexPath) as! SyllabusDetailsTableViewCell
            let chapterAttached:LogDetailSyllabus = cellDataSource.attachedObject as! LogDetailSyllabus
            cell.imageViewStatus.alpha = 0
            cell.labelChapterNumber.text = "\(chapterAttached.unitName)"
            cell.labelChapterDetails.text = "\(chapterAttached.chapter.chapterName)"
            cell.viewSeperator.alpha = 0
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellDataSource = arrayDataSource[indexPath.row]
        switch cellDataSource.logsCellType! {
        case .LogDetails:
            return 200
        case .SyllabusDetail:
            return 80
        }
    }
}

extension LogsDetailViewController:LogsDetailCellDelegate{
    func actionDidDeleteAttendance(_ indexpath: IndexPath) {
        guard let logDetailsObj = self.arrayDataSource[indexpath.row].attachedObject as? LogDetails,
            let attendanceId = Int(logDetailsObj.attendanceId)
            else {
                return
        }
        
        print("selected attendance id = \(attendanceId)")
        
        let alertController = UIAlertController(title: "Delete Attendance!", message: "Are you sure you want to delete this lecture's log?", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter a reason to delete."
            textField.isSecureTextEntry = false
            
        }
        
        
        let confirmAction = UIAlertAction(title: "SUBMIT", style: .default) { [weak alertController, weak self] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            NotificationCenter.default.removeObserver(alertController)
            let deleteAttendanceObj = DeleteAttendanceObject(attendanceId: attendanceId, reasonToDelete: textField.text ?? "")
            self?.makeDeleAttendanceRequest(deleteAttendanceObj)
            print("Reason entered is: \(textField.text ?? "")")
        }
        confirmAction.isEnabled = false
        
        //enable confirm only when textfield has reason.
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: alertController.textFields?.first, queue: .main) { (notification) in
            confirmAction.isEnabled = !(alertController.textFields?.first?.text?.isEmpty ?? true)
        }
        
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func actionDidEditAttendance(_ indexpath: IndexPath) {
        
        
        guard let logDetailsObj = self.arrayDataSource[indexpath.row].attachedObject as? LogDetails,
            let attendanceId = Int(logDetailsObj.attendanceId)
            else {
                return
            }
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:StudentsListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentList) as! StudentsListViewController
        destinationVC.selectedAttendanceId = attendanceId
        destinationVC.isEditAttendanceFlow = true
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension LogsDetailViewController:ViewLogsCalenderDelegate{
    func getLogs(fromDate: String, toDate: String) {
        self.dismissCalenderView()
        if self.isCollegeLogsSubjectData{
            self.getCollgeProfessorLogDetails(fromDate: fromDate, toDate: toDate)
        }else{
            self.getLogDetails(fromDate: fromDate, toDate: toDate)
        }
    }
    
    func dismissCalenderView(){
        self.calenderView?.removeFromSuperview()
    }
}

extension LogsDetailViewController{
    struct DeleteAttendanceObject {
        let attendanceId:Int
        let reasonToDelete:String
    }
    func makeDeleAttendanceRequest(_ object: DeleteAttendanceObject){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.deleteAttendanceRequest
        var parameters = [String:Any]()
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        parameters["attendance_id"] = "\(object.attendanceId)"
        parameters["comment"] = "\(object.reasonToDelete)"
        
        manager.apiPost(apiName: "Make delete attendance request for id \(object.attendanceId)", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let status = response["status"] as? NSNumber else{
                return
            }
            if (status == 200){
                guard let message:String = response["message"] as? String else { return }
                self.showAlertWithTitle(nil, alertMessage: message)
            }
            else{
                self.showAlertWithTitle("Failed", alertMessage: "Failed to create request, Please retry.")
            }
        }) { (success, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            #if DEBUG
            self.showAlertWithTitle(nil, alertMessage: message)
            #endif
        }

        
    }
}
