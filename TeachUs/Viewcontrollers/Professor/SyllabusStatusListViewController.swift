//
//  SyllabusStatusListViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class SyllabusStatusListViewController: UIViewController {

    @IBOutlet weak var tableViewSyllabus: UITableView!
    var parentNavigationController : UINavigationController?
    var userType:LoginUserType!
    var arrayDataSource:[Subject] = []

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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getSyllabus(){
        let manager = NetworkHandler()
        
        //http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getSyllabusSummary/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=1
        
        switch userType! {
        case .Student:
            manager.url = URLConstants.StudentURL.getSyllabusSummary +
                "\(UserManager.sharedUserManager.getAccessToken())" +
            "?studentId=\(UserManager.sharedUserManager.getUserId())"
            break
        
        case .Professor:
//            manager.url = URLConstants.TecacherURL.getSyllabusSummary +
//                "\(UserManager.sharedUserManager.getAccessToken())" +
//            "?professorId=\(UserManager.sharedUserManager.getUserId())"
            manager.url = URLConstants.BaseUrl.baseURL + UserManager.sharedUserManager.teacherProfile.syllabusStatusUrl
            
            break
            
        default:
            break
        }
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
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
        cell.labelNumberOfLectures.text = "\(arrayDataSource[indexPath.section].numberOfLectures!)"
        cell.labelSubject.text = "\(arrayDataSource[indexPath.section].subjectName!)"
        cell.labelAttendancePercent.text = "\(arrayDataSource[indexPath.section].completion!)"
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
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
        destinationVC.arrayDataSource = self.arrayDataSource[indexPath.section].topics!
        destinationVC.completionStatus = self.arrayDataSource[indexPath.section].completion!
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
