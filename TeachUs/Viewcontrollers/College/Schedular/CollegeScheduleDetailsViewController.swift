//
//  CollegeScheduleDetailsViewController.swift
//  TeachUs
//
//  Created by iOS on 12/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class CollegeScheduleDetailsViewController: BaseViewController {

    @IBOutlet weak var tableviewScheduleDetails: UITableView!
    var scheduleDetails:ClassScheduleDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewScheduleDetails.dataSource = self
        tableviewScheduleDetails.delegate  = self
        tableviewScheduleDetails.estimatedRowHeight = 44.0
        tableviewScheduleDetails.rowHeight = UITableViewAutomaticDimension
        tableviewScheduleDetails.addSubview(refreshControl)
        getScheduleDetails()
    }
    
    
    
    func getScheduleDetails() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeScheduleDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get College Schedules Details", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.scheduleDetails = try decoder.decode(ClassScheduleDetails.self, from: response)
                if !(self.scheduleDetails?.schedules?.isEmpty ?? true){
                    self.tableviewScheduleDetails.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }

    }
    
    @IBAction func actionCloseView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CollegeScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
