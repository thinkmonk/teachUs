//
//  StudentsAttendanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class StudentsListViewController: BaseViewController {

    var subject:CollegeSubjects!
    var arrayDataSource:[EnrolledStudentDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(subject != nil)
        {
            self.title = subject.subjectName!
            self.getEnrolledStudentsList()
        }
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: UIColor.white)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getEnrolledStudentsList(){
        let manager = NetworkHandler()
        //"http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getEnrolledStudentList/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=1"
        
        manager.url = URLConstants.BaseUrl.baseURL + self.subject.enrolledStudentListUrl!
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get enrolled Students", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                
                let studentDetailArray = response["studentDetail"] as! [[String:Any]]
                for student in studentDetailArray{
                    let studentDetail = Mapper<EnrolledStudentDetail>().map(JSON: student)
                    self.arrayDataSource.append(studentDetail!)
                }
                if(self.arrayDataSource.count > 0){
                    self.setUpTableView()
                }
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
    }
    
    func setUpTableView(){
        print("Yoo")
    }

}
