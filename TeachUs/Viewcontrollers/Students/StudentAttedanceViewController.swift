//
//  StudentAttedanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import XLPagerTabStrip

class StudentAttedanceViewController: UIViewController {
    var parentNavigationController : UINavigationController?
    @IBOutlet weak var viewAttendanceMonth: UIView!
    @IBOutlet weak var labelLectureCount: UILabel!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var labelMonthType: UILabel!
    @IBOutlet weak var tableViewStudentAttendance: UITableView!
    @IBOutlet weak var viewHeaderBackground: UIView!
    
    var arrayDataSource:StudentAttendance!
    let monthDropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAttendance(0)
        self.tableViewStudentAttendance.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        self.tableViewStudentAttendance.delegate = self
        self.tableViewStudentAttendance.dataSource = self
        self.tableViewStudentAttendance.alpha = 0.0
        self.setUpDropDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getAttendance(_ forMonth:Int){
        /*
        //http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/student/getAttendence/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?studentId=1
//        manager.url = URLConstants.StudentURL.getAttendence +
//            "\(UserManager.sharedUserManager.getAccessToken())" +
//            "?studentId=\(UserManager.sharedUserManager.getUserId())"
        
        manager.url = URLConstants.BaseUrl.baseURL + UserManager.sharedUserManager.userStudent.attendanceUrl!
        if (forMonth > 0){
            manager.url?.append("&month=\(forMonth)")
        }
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get Attendance for student", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            self.arrayDataSource = Mapper<StudentAttendance>().map(JSON: response)
            self.setUpView()
            self.tableViewStudentAttendance.reloadData()
            self.showTableView()
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
         */
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let strYear = dateFormatter.string(from: date)

        
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.getClassAttendance
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "year":"\(strYear)",
            "month":"\(forMonth)"
        ]
        
        manager.apiPost(apiName: " Get user Attendance for month \(forMonth)", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.arrayDataSource = Mapper<StudentAttendance>().map(JSON: response)
            self.setUpView()
            self.tableViewStudentAttendance.reloadData()
            self.showTableView()

            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
        
    }
    
    
    func setUpDropDown(){
        self.monthDropdown.anchorView = self.viewAttendanceMonth
        self.monthDropdown.bottomOffset = CGPoint(x: 0, y: monthDropdown.height())
        self.monthDropdown.dataSource = [
            "Overall",
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ]
        self.monthDropdown.selectionAction = { [unowned self] (index, item) in
            self.labelMonthType.text = "\(item)"
            self.getAttendance(index)
        }
        DropDown.appearance().backgroundColor = UIColor.white
    }

    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(StudentAttedanceViewController.showMonthPicker))
        tap.numberOfTapsRequired = 1
        self.viewAttendanceMonth.addGestureRecognizer(tap)
        
        self.labelLectureCount.text = "\(self.arrayDataSource.overallPercenage!)%  ( \(self.arrayDataSource.totalPresentCount!)/\(self.arrayDataSource.totalLecture!) )"
        self.viewHeaderBackground.alpha = self.arrayDataSource.subjectAttendance.count > 0 ? 1 : 0
        
    }
    
    func showTableView(){
        self.tableViewStudentAttendance.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewStudentAttendance.alpha = 1.0
            self.tableViewStudentAttendance.transform = CGAffineTransform.identity
        }
    }
    
    @objc func showMonthPicker(){
        monthDropdown.show()
    }
}

extension StudentAttedanceViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arrayDataSource != nil){
            return 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.arrayDataSource != nil){
            return self.arrayDataSource.subjectAttendance.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewStudentAttendance.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //***have reused the syllabus-details cell***
        
        
        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath) as! SyllabusStatusTableViewCell
        cell.labelSubject.text = self.arrayDataSource.subjectAttendance[indexPath.section].subjectName
        cell.labelNumberOfLectures.text = "\(self.arrayDataSource.subjectAttendance[indexPath.section].percentage!)%"
        cell.labelAttendancePercent.text = "\(self.arrayDataSource.subjectAttendance[indexPath.section].presentCount!)/\(self.arrayDataSource.subjectAttendance[indexPath.row].totalCount!)"
        cell.selectionStyle = .none
        return cell
    }
}

extension StudentAttedanceViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance")
    }
}
