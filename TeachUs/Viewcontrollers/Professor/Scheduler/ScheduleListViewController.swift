//
//  ScheduleListViewController.swift
//  TeachUs
//
//  Created by iOS on 31/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ScheduleListViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    var collegeScheduleList:ClassScheduleDetails?
    var parentNavigationController : UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.colors.backgroundColor
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.addSubview(refreshControl)
        tableview.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)

        getClassSchedule()
    }

    @IBAction func actionAdd(_ sender: Any) {
        //AddNewScheduleViewControllerId
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController:AddNewScheduleViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.addNewScheduleId) as! AddNewScheduleViewController
        detailsViewController.scheduleData = SchedularData(flowType: .professorAdd)
        self.navigationController?.pushViewController(detailsViewController, animated: true)

    }
    
    override func refresh(sender: AnyObject) {
        self.getClassSchedule()
        super.refresh(sender: sender)
    }
    
}

extension ScheduleListViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return collegeScheduleList?.schedules?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let schedule = collegeScheduleList?.schedules?[indexPath.section] else {
            return UITableViewCell()
        }
        
        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath)  as! SyllabusStatusTableViewCell
        
        cell.labelSubject.text          = "\(schedule.scheduleClass ?? "") \n \(schedule.subjectName ?? "")"
        cell.labelNumberOfLectures.text = "\(schedule.todaysSchedule ?? "")"
        cell.labelAttendancePercent.text = "\(schedule.totalSchedules ?? "")"
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableview.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedSchedule = self.collegeScheduleList?.schedules?[indexPath.section] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailsViewController:ScheduleDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.lecturerScheduleDetails) as! ScheduleDetailsViewController
            detailsViewController.schedule = selectedSchedule
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }

    
}


extension ScheduleListViewController {
    func getClassSchedule() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.professorSchedules
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get Professor Schedules", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.collegeScheduleList = try decoder.decode(ClassScheduleDetails.self, from: response)
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

extension ScheduleListViewController:IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Schedule")
    }
}
