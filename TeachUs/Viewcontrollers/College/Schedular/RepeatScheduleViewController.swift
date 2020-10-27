//
//  RepeatScheduleViewController.swift
//  TeachUs
//
//  Created by iOS on 28/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class RepeatScheduleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dateSelected:Date?
    var classId:String?
    var scheduleDetails:ClassScheduleDetails?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        guard let dateObjs = dateSelected else {
            return
        }
        getScheduleDetails(between: dateObjs.getDateString(format: "YYYY-MM-dd"), dateObjs.getDateString(format: "YYYY-MM-dd"))
    }
    
    func makeDataSource() {
        
    }

}

extension RepeatScheduleViewController {
    func getScheduleDetails(between toDate:String, _ fromDate:String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeScheduleDetails
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : self.classId ?? "",
            "to_date" : toDate,
            "from_date" : fromDate        ] as [String : Any]
        
        manager.apiPostWithDataResponse(apiName: "Get College Schedules Details", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.scheduleDetails = try decoder.decode(ClassScheduleDetails.self, from: response)
                if !(self.scheduleDetails?.schedules?.isEmpty ?? true) {
                    self.makeDataSource()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
}
