//
//  ProfessorAttedanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfessorAttedanceViewController: BaseViewController {

    var parentNavigationController : UINavigationController?
    var arrayCollegeList:[College]? = []
    var viewCollegeList:CollegeList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfessorAttedanceViewController")
        self.view.backgroundColor = UIColor.clear
        getCollegeSummaryForProfessor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCollegeSummaryForProfessor(){
        let manager = NetworkHandler()
        
        /*
        //"http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/teacher/getCollegeSummary/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?professorId=1"
        
        manager.url = URLConstants.TecacherURL.collegeSummary +
            "\(UserManager.sharedUserManager.getAccessToken())" +
            "?professorId=\(UserManager.sharedUserManager.getUserId())"
        */
        
        manager.url = URLConstants.BaseUrl.baseURL + UserManager.sharedUserManager.teacherProfile.attendenceUrl
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get College Summary for professor", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            guard let colleges = response["college"] as? [[String:Any]] else{
                return
            }
            
            for college in colleges{
                let tempCollege = Mapper<College>().map(JSONObject: college)
                self.arrayCollegeList?.append(tempCollege!)
            }
            self.makeCollegesTableView()
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
    }
    
    
    func makeCollegesTableView(){
        viewCollegeList = CollegeList.instanceFromNib() as! CollegeList
        viewCollegeList.setUpTableView(arrayCollegeList!)
        viewCollegeList.delegate = self
        viewCollegeList.showView(self.view)
    }
}

extension ProfessorAttedanceViewController:CollegeListDelegate{
    
    func selectedSubject(_ subject: CollegeSubjects) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

            let destinationVC:StudentsListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentList) as! StudentsListViewController
            destinationVC.subject = subject
            
            self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
