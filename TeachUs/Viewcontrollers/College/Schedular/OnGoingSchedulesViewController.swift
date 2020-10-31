//
//  OnGoingSchedulesViewController.swift
//  TeachUs
//
//  Created by iOS on 31/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class OnGoingSchedulesViewController: BaseViewController {
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var tableview: UITableView!
    private var collegeScheduleList:OnGoingSchedules?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "ScheduleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableViewAutomaticDimension

        getClassSchedule()
    }

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OnGoingSchedulesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.collegeScheduleList?.schedules?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScheduleDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.schdeduleDetailsCellId, for: indexPath)  as! ScheduleDetailsTableViewCell
        guard let scheduleObj = self.collegeScheduleList?.schedules?[indexPath.section] else { return UITableViewCell() }
        cell.setUpCell(details: scheduleObj, cellType: .liveLecture)
        cell.buttonJoin.indexPath = indexPath
        
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableview.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView

    }
}
// MARK:- ScheduleDetailCellDelegate
extension OnGoingSchedulesViewController: ScheduleDetailCellDelegate {

    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath,
              let schedule = self.collegeScheduleList?.schedules?[indexPath.section],
              let scheduleURL = schedule.scheduleURL,
              let url = URL(string: scheduleURL) else {
            return
        }
        UIApplication.shared.open(url)
    }
}


//MARK:- API CALL
extension OnGoingSchedulesViewController {
    func getClassSchedule(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getCurrentSchedule
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get Current College Schedules", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.collegeScheduleList = try decoder.decode(OnGoingSchedules.self, from: response)
                if !(self.collegeScheduleList?.schedules?.isEmpty ?? true){
                    self.tableview.reloadData()
                    self.tableview.isHidden = false
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

