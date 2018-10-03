//
//  SyllabusStatusListViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import XLPagerTabStrip

class SyllabusStatusListViewController: BaseViewController {

    @IBOutlet weak var tableViewSyllabus: UITableView!
    var parentNavigationController : UINavigationController?
    var userType:LoginUserType!
    var arrayDataSource:[Subject] = []
    var selectedClassId:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SyllabusStatusListViewController")
        self.view.backgroundColor = UIColor.clear
        self.tableViewSyllabus.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        self.getSyllabus()
        self.tableViewSyllabus.alpha = 0
        self.tableViewSyllabus.estimatedRowHeight = 44.0
        self.tableViewSyllabus.rowHeight = UITableViewAutomaticDimension
        self.view.backgroundColor = UIColor.rgbColor(236, 243, 248)
        self.tableViewSyllabus.addSubview(refreshControl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresh(sender: AnyObject) {
        self.getSyllabus()
        super.refresh(sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.userType == LoginUserType.College){
            self.addGradientToNavBar()
        }
    }
    
    func getSyllabus(){
        let manager = NetworkHandler()
        var parameters = [String:Any]()
        //http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getSyllabusSummary/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=1
        switch userType! {
        case .Student:
            manager.url = URLConstants.StudentURL.syllabusSubjectStatus
            parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
            break
        
        case .Professor:
            manager.url = URLConstants.ProfessorURL.syllabusSubjectStatus
            parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
            break
            
        case .College:
            manager.url = URLConstants.CollegeURL.getCollegeSubjectSyllabusList
            parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
            parameters["class_id"] = self.selectedClassId
            break
        }
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        manager.apiPost(apiName: "Get Syllabus for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let subjects = response["syllabus_subject_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for subject in subjects{
                let tempSubject = Mapper<Subject>().map(JSON: subject)
                self.arrayDataSource.append(tempSubject!)
            }
            self.arrayDataSource.sort(by: { ($0.courseName,$0.classDivision ,$0.subjectName) < ($1.courseName,$0.classDivision,$1.subjectName) })

            self.makeTableView()
            self.tableViewSyllabus.reloadData()
            self.showTableView()

        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)

        }
        
        /*
        manager.apiGet(apiName: "Get Syllabus for professor", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let subjects = response["subjectWise"] as? [[String:Any]] else{
                return
            }
            
            for subject in subjects{
                let tempSubject = Mapper<Subject>().map(JSON: subject)
                self.arrayDataSource.append(tempSubject!)
            }
            self.makeTableView()
            self.tableViewSyllabus.reloadData()
            self.showTableView()
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
        
        */
    }
    
    func makeTableView(){
        self.tableViewSyllabus.delegate = self
        self.tableViewSyllabus.dataSource = self
    }
    
    func showTableView(){
        self.tableViewSyllabus.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewSyllabus.alpha = 1.0
            self.tableViewSyllabus.transform = CGAffineTransform.identity
        }
    }
}

extension SyllabusStatusListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath)  as! SyllabusStatusTableViewCell
        
        let cellSubject = arrayDataSource[indexPath.section]
        cell.labelNumberOfLectures.text = "\(cellSubject.numberOfLectures)"
        cell.labelSubject.text = "\(cellSubject.courseName) - \(cellSubject.classDivision) \(cellSubject.subjectName)"
        cell.labelSubject.text = self.userType! == LoginUserType.Professor ? "\(cellSubject.courseName) - \(cellSubject.classDivision) \(cellSubject.subjectName)" : "\(cellSubject.subjectName)"
        cell.labelAttendancePercent.text = "\(cellSubject.completion)%"
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewSyllabus.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:SyllabusDetailsViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.syllabusDetails) as! SyllabusDetailsViewController
        destinationVC.completionStatus = self.arrayDataSource[indexPath.section].completion
        destinationVC.selectedSubject = self.arrayDataSource[indexPath.section]
        destinationVC.userType = self.userType
        destinationVC.selectedClassId  = self.selectedClassId
        destinationVC.title = "\(arrayDataSource[indexPath.section].subjectName)"
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension SyllabusStatusListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Syllabus Status")
    }
}
