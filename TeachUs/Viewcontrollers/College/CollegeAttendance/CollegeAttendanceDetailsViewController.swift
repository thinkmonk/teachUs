//
//  CollegeAttendanceDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 3/30/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa

class CollegeAttendanceDetailsViewController: BaseViewController {

    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonMaiReport: UIButton!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var labelToDate: UILabel!
    @IBOutlet weak var buttonFromDate: UIButton!
    @IBOutlet weak var buttonToDate: UIButton!
    @IBOutlet weak var tableViewStudentList: UITableView!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var buttonAllSubject: UIButton!
    @IBOutlet weak var viewSubjectName: UIView!
    @IBOutlet weak var labelNoRecordFound: UILabel!
    var arraySubjectLIst:[CollegeSubjects] = []
    var arrayStudentList:[EnrolledStudentDetail] = []
    let collegeSubjectDropdown = DropDown()
    var collegeClass:CollegeAttendanceList!
    var fromDatePicker: ViewDatePicker!
//    var toDatePicker: ViewDatePicker!
    var toDate:Date!
    var fromDate:Date!
    var selectedSubject:CollegeSubjects!
    var activeLabel:UILabel!
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MMM-dd"
        return df
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(self.collegeClass.courseName) - \(self.collegeClass.classDivision)"
        self.navigationController!.navigationBar.topItem!.title = ""

        self.labelNoRecordFound.alpha = 0
        self.buttonSubmit.makeViewCircular()
//        self.buttonMaiReport.makeViewCircular()
        self.addGradientToNavBar()
        getSubjectList()
        self.initDatePicker()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceDetailsViewController.showDropDown(_:)))
        self.labelSubject.isUserInteractionEnabled = true
        self.labelSubject.addGestureRecognizer(tap)

        
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceDetailsViewController.showDatePicker(_:)))
        self.labelFromDate.isUserInteractionEnabled = true
        self.labelFromDate.addGestureRecognizer(dateTap)
        
        
        
        let dateToTap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceDetailsViewController.showDatePicker(_:)))
        self.labelToDate.isUserInteractionEnabled = true
        self.labelToDate.addGestureRecognizer(dateToTap)
        
        self.tableViewStudentList.register(UINib(nibName: "StudentProfileTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.StudentProfileTableViewCellId)
        self.tableViewStudentList.delegate = self
        self.tableViewStudentList.dataSource = self
        self.tableViewStudentList.estimatedRowHeight = 60
        self.tableViewStudentList.rowHeight = UITableViewAutomaticDimension
        self.tableViewStudentList.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonAllSubject.makeTableCellEdgesRounded()
        self.viewSubjectName.makeTableCellEdgesRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.labelToDate.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.rgbColor(239.0, 239.0, 239.0), thickness: 1)
        self.labelFromDate.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.rgbColor(239.0, 239.0, 239.0), thickness: 1)
    }
    
    func getSubjectList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classSubjectList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.collegeClass.classId)"
        ]
        
        manager.apiPost(apiName: " Get class Subject List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let subjectListArray = response["subject_list"] as? [[String:Any]] else{
                return
            }
            for subject in subjectListArray{
                let tempList = Mapper<CollegeSubjects>().map(JSONObject: subject)
                self.arraySubjectLIst.append(tempList!)
            }
            self.setUpDropDown()
            self.getAttendance(subject: nil)
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    func setUpDropDown(){
        self.collegeSubjectDropdown.anchorView = self.labelSubject
        self.collegeSubjectDropdown.bottomOffset = CGPoint(x: 0, y: viewSubjectName.height())
        self.collegeSubjectDropdown.width = self.view.width() * 0.80
        
        for subject in arraySubjectLIst{
            self.collegeSubjectDropdown.dataSource.append(subject.subjectName!)
            
            self.collegeSubjectDropdown.selectionAction = { [unowned self] (index, item) in
                self.selectedSubject = self.arraySubjectLIst[index]
                self.labelSubject.text = "\(self.arraySubjectLIst[index].subjectName ?? "")"
                self.getAttendance(subject: self.arraySubjectLIst[index])
            }
        }
    }
    
    func getAttendance( subject:CollegeSubjects?){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.arrayStudentList.removeAll()
        // Set date format
        let urlDateFormatter = DateFormatter()
        urlDateFormatter.dateFormat = "YYYY-MM-dd"
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classStudentLIst
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.collegeClass.classId)",
            "subject_id":"\(subject?.subjectId! ?? "0")",
        ]
        
        if(self.fromDate != nil)
        {
            parameters["from_date"] = urlDateFormatter.string(from: self.fromDate)
        }
        
        if(self.toDate != nil)
        {
            parameters["to_date"] = urlDateFormatter.string(from: self.toDate)
        }
        
        manager.apiPost(apiName: " Get class Student List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let studentListArray = response["student_list"] as? [[String:Any]] else{
                self.tableViewStudentList.reloadData()
                self.labelNoRecordFound.text = response["message"] as? String
                self.labelNoRecordFound.alpha = 1
                return
            }
            self.labelNoRecordFound.alpha = 0

            for student in studentListArray{
                let tempList = Mapper<EnrolledStudentDetail>().map(JSONObject: student)
                self.arrayStudentList.append(tempList!)
            }
            self.arrayStudentList.sort(by: { $0.studentRollNo!.localizedStandardCompare($1.studentRollNo!) == .orderedAscending})
            self.showTableView()
            self.tableViewStudentList.reloadData()
            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func initDatePicker(){
        if(fromDatePicker == nil){
            fromDatePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
            fromDatePicker.setUpPicker(type: .date)
            fromDatePicker.buttonOk.addTarget(self, action: #selector(CollegeAttendanceDetailsViewController.dismissDatePicker), for: .touchUpInside)
            fromDatePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
            fromDatePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
            self.toDate = Date()
            self.labelToDate.text = self.dateFormatter.string(from: self.toDate!)
            self.fromDate = NSCalendar.current.date(byAdding: .month, value: -1, to: Date())
            self.labelFromDate.text = self.dateFormatter.string(from: self.fromDate!)
            
            
        }
//        if(toDatePicker == nil){
//            toDatePicker = ViewDatePicker.instanceFromNib() as! ViewDatePicker
//            toDatePicker.setUpPicker(type: .date)
//            toDatePicker.buttonOk.addTarget(self, action: #selector(CollegeAttendanceDetailsViewController.dismissDatePicker), for: .touchUpInside)
//            toDatePicker.picker.minimumDate = NSCalendar.current.date(byAdding: .month, value: -6, to: Date())
//            toDatePicker.picker.maximumDate = NSCalendar.current.date(byAdding: .month, value: 0, to: Date())
//        }
    }
    
    
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
    
    func showTableView(){
        self.tableViewStudentList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewStudentList.alpha = 1.0
            self.tableViewStudentList.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        self.collegeSubjectDropdown.show()
    }
    
    
    
    @IBAction func getAttendanceForAllSubjects(_ sender: Any) {
        self.selectedSubject = nil
        self.getAttendance(subject: nil)
        self.labelSubject.text = "All Subjects"
        
    }
    
    func verifyDate() -> Bool{
        if(self.fromDate == nil  || self.toDate == nil){
            self.showAlterWithTitle(nil, alertMessage: "Date Range not selected!")
        }else if(self.fromDate < self.toDate){
            return true
        }else{
            self.showAlterWithTitle("Wrong Date Range", alertMessage: "From date should be lesser than to date!")
        }
        return false
    }
    
    
    @IBAction func getAttendanceForDateRange(_ sender: Any) {
        if(self.verifyDate()){
            self.getAttendance(subject: self.selectedSubject)
        }
    }
    
    @IBAction func mailAttendanceReport(_ sender: Any) {
        if(self.verifyDate()){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let modalViewController:CollegeAttendanceMailReportViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeAttendanceMailReportViewControllerId) as! CollegeAttendanceMailReportViewController
            modalViewController.collegeClass = self.collegeClass
            modalViewController.modalPresentationStyle = .overCurrentContext
            
            let urlDateFormatter = DateFormatter()
            urlDateFormatter.dateFormat = "YYYY-MM-dd"

            
            modalViewController.fromDate = self.fromDate != nil ? urlDateFormatter.string(from: self.fromDate) : ""
            modalViewController.toDate = self.toDate != nil ? urlDateFormatter.string(from: self.toDate) : ""
            modalViewController.delegate = self
            present(modalViewController, animated: true, completion: nil)
        }
    }
}

//MARK:- Table view delegate and datasource methods
extension CollegeAttendanceDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayStudentList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : StudentProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.StudentProfileTableViewCellId, for: indexPath) as! StudentProfileTableViewCell
        let object:EnrolledStudentDetail = arrayStudentList [indexPath.section]
        cell.labelName.text = object.studentName
        cell.labelRollNumber.text = "\(object.studentRollNo! )"
        cell.labelAttendanceCount.text = "\(object.lectureAttended! )"
        cell.labelAttendancePercent.text = "\(object.percentage! ) %"
        cell.clipsToBounds = true
        cell.imageViewProfile.imageFromServerURL(urlString: (object.imageUrl!), defaultImage: Constants.Images.defaultMale)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewStudentList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    
}


extension CollegeAttendanceDetailsViewController:MailReportViewControllerDelegate {
    func  reportMailed() {
        self.navigationController?.popViewController(animated: true)
    }
}



