//
//  LogsListViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfessorLogsListViewController: UIViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[ProfessorLogs]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfessorLogsListViewController")
        self.view.backgroundColor = UIColor.clear
        self.getLogs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLogs(){
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)

        let manager = NetworkHandler()
//        manager.url = URLConstants.BaseUrl.baseURL + UserManager.sharedUserManager.userTeacher.logsUrl
        manager.url = "http://ec2-52-40-212-186.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getDateWiseSubjectLogs/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1&subjectId=1"
        manager.apiGet(apiName: "Get professor logs", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            guard let logs = response["detail"] as? [[String:Any]] else{
                return
            }
            for log in logs{
                let tempLog = Mapper<ProfessorLogs>().map(JSON: log)
                self.arrayDataSource.append(tempLog!)
            }
            self.makeTableView()
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()

        }
    }
    
    func makeTableView(){
        print(self.arrayDataSource)
    }

}
