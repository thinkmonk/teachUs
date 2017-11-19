//
//  StudentAttedanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class StudentAttedanceViewController: UIViewController {
    var parentNavigationController : UINavigationController?
    
    var arrayDataSource:SubjectAttendance!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAttendance()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getAttendance(){
        let manager = NetworkHandler()
        
        
        //http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/student/getAttendence/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?studentId=1
        manager.url = URLConstants.StudentURL.getAttendence +
            "\(UserManager.sharedUserManager.getAccessToken())" +
            "?studentId=\(UserManager.sharedUserManager.getUserId())"
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get Attendance for student", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            self.arrayDataSource = Mapper<SubjectAttendance>().map(JSON: response)
            print(self.arrayDataSource)
            
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
        
    }

}
