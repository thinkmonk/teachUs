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
        if self.isCollegeLogsSubjectData{
            self.getCollgeProfessorLogDetails(fromDate: self.calenderView?.fromDateString ?? "", toDate: self.calenderView?.toDateStirng ?? "")
        }else{
            self.getLogs(fromDate: self.calenderView?.fromDateString ?? "", toDate: self.calenderView?.toDateStirng ?? "")
        }
        self.tableLogsDetail.register(UINib(nibName: "LogsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId)
        self.tableLogsDetail.register(UINib(nibName: "SyllabusDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId)
        
        var image = UIImage(named:Constants.Images.calendarWhite)
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(LogsDetailViewController.showCalenderView))
        self.setUpButtons()
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
            
            self.arrayLogsDetails.sort(by: { ($0.lectureDate.convertToDate()!) > ($1.lectureDate.convertToDate()!) })
            self.makeDataSource()
            self.showTableView()
        }) { (success, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlterWithTitle(nil, alertMessage: message)
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
            self.showAlterWithTitle(nil, alertMessage: message)
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
                    attachedSyllabus.unitName = unit.unitName
                    attachedSyllabus.unitNumber = unit.unitNumber
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
            return 180
        case .SyllabusDetail:
            return 80
        }
    }
}

extension LogsDetailViewController:LogsDetailCellDelegate{
    func actionDidEditAttendance(_ indexpath: IndexPath) {

        print("selected attendance id = \((self.arrayDataSource[indexpath.row].attachedObject as! LogDetails).attendanceId )")
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:StudentsListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentList) as! StudentsListViewController
        destinationVC.selectedAttendanceId = Int((self.arrayDataSource[indexpath.row].attachedObject as! LogDetails).attendanceId)
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
