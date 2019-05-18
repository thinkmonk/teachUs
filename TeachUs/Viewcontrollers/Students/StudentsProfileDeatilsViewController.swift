//
//  StudentsProfileDeatilsViewController.swift
//  TeachUs
//
//  Created by ios on 5/11/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class StudentsProfileDeatilsViewController: BaseViewController {

    @IBOutlet weak var tableStudentProfileDetails: UITableView!
    var studentProfileDetails:StudentProfileDetails?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.addGradientToNavBar()
        self.getStudentDetails()
    }
    
    func getStudentDetails(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.getStudentProfileDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        manager.apiPostWithDataResponse(apiName: "Get student profile", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.studentProfileDetails = try decoder.decode(StudentProfileDetails.self, from: response)
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }

    }
}
