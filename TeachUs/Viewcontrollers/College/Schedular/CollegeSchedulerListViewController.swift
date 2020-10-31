//
//  CollegeSchedulerListViewController.swift
//  TeachUs
//
//  Created by iOS on 12/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class CollegeSchedulerListViewController: BaseViewController {

    @IBOutlet weak var tableviewScheduleList: UITableView!
    @IBOutlet weak var buttonLiveLectures: UIButton!
    var parentNavigationController : UINavigationController?
    var collegeScheduleList:ClassScheduleDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewScheduleList.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        tableviewScheduleList.dataSource = self
        tableviewScheduleList.delegate  = self
        tableviewScheduleList.estimatedRowHeight = 44.0
        tableviewScheduleList.rowHeight = UITableViewAutomaticDimension
        tableviewScheduleList.addSubview(refreshControl)
        getClassSchedule()
        buttonLiveLectures.themeRedButton()
        buttonLiveLectures.setTitle("On going lectures", for: .normal)
        self.buttonLiveLectures.isHidden = true
    }
    
    
    @IBAction func actionShowLiveLectures(_ sender: Any) {
        
    }
    
    override func refresh(sender: AnyObject) {
        self.getClassSchedule()
        super.refresh(sender: sender)
    }

    
    
    func getClassSchedule() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeschedule
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get College Schedules", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.collegeScheduleList = try decoder.decode(ClassScheduleDetails.self, from: response)
                if !(self.collegeScheduleList?.schedules?.isEmpty ?? true){
                    self.tableviewScheduleList.reloadData()
                    self.buttonLiveLectures.isHidden = false
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

extension CollegeSchedulerListViewController:UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.labelSubject.text          = "\(schedule.scheduleClass ?? "")"
        cell.labelNumberOfLectures.text = "\(schedule.todaysSchedule ?? "")"
        cell.labelAttendancePercent.text = "\(schedule.totalSchedules ?? "")"
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableviewScheduleList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedSchedule = self.collegeScheduleList?.schedules?[indexPath.section] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailsViewController:CollegeScheduleDetailsViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.scheduleDetials) as! CollegeScheduleDetailsViewController
            detailsViewController.schedule = selectedSchedule
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }

    
}

extension CollegeSchedulerListViewController:IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Schedule")
    }
}
