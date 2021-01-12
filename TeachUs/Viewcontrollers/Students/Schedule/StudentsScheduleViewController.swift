//
//  StudentsScheduleViewController.swift
//  TeachUs
//
//  Created by iOS on 04/11/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StudentsScheduleViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var scheduleDetails:ClassScheduleDetails?
    private var currentToDate:String!
    private var currentFromDate:String!
    var arrayDataSource = [ScheduleDetailDataSource]()
    var parentNavigationController : UINavigationController?
    var isParentsProfileFlow: Bool = false
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.colors.backgroundColor
        tableView.register(UINib(nibName: "ScheduleDateTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.scheduleDetailsDateCellId)
        tableView.register(UINib(nibName: "ScheduleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh(sender: self)
    }

    
    override func refresh(sender: AnyObject) {
        let toDate = currentToDate ?? Date().addDays(7).getDateString(format: "YYYY-MM-dd")
        let fromDate = currentFromDate ?? Date().getDateString(format: "YYYY-MM-dd")
        
        getScheduleDetails(to: toDate, from: fromDate)
        super.refresh(sender: sender)
    }
    
    func makeDataSource() {
        arrayDataSource.removeAll()
        

        for schedule in self.scheduleDetails?.schedules ?? [] {
            let dateString = schedule.date?.getDateDisplayString()
            let dateDs = ScheduleDetailDataSource(detailsCell: .ScheduleDate, detailsObject: dateString)
            arrayDataSource.append(dateDs)
            
            for details in schedule.scheduleDetails ?? [] {
                let scheduleDS = ScheduleDetailDataSource(detailsCell: .SchdeuleDetails, detailsObject: details)
                arrayDataSource.append(scheduleDS)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func actionDatePicker(_ sender: Any) {
        // DatePicker //datePickerVcId
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController:SchedularDatePickerViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.scheduleDatePickerVc) as! SchedularDatePickerViewController
        detailsViewController.modalPresentationStyle = .custom
        slideInTransitioningDelegate.direction = .bottom
        slideInTransitioningDelegate.disableCompactHeight = true
        detailsViewController.transitioningDelegate = slideInTransitioningDelegate
        detailsViewController.modalPresentationStyle = .custom
        detailsViewController.delegate = self
        present(detailsViewController, animated: true, completion: nil)
        
    }
}

extension StudentsScheduleViewController: DatePickerDelegate {
    func dateSelected(from fromDate: Date, to toDate: Date) {
        getScheduleDetails(to: toDate.getDateString(format: "YYYY-MM-dd"), from: fromDate.getDateString(format: "YYYY-MM-dd"))
    }
}


extension StudentsScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = arrayDataSource[indexPath.section]
        
        switch dataSource.cellType {
        
        case .ScheduleDate:
            let cell:ScheduleDateTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.scheduleDetailsDateCellId, for: indexPath)  as! ScheduleDateTableViewCell
            let dateString = dataSource.attachedObject as? String ?? "NA"
            cell.labelDate.text = dateString
            cell.selectionStyle = .none
            return cell
            
        case .SchdeuleDetails:
            let cell:ScheduleDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.schdeduleDetailsCellId, for: indexPath)  as! ScheduleDetailsTableViewCell
            guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail else { return UITableViewCell() }
            if isParentsProfileFlow {
                cell.setUpCell(details: scheduleObj, cellType: .parentsSchedule)
            }else {
                cell.setUpCell(details: scheduleObj, cellType: .studentSchedule)
            }
            cell.buttonJoin.indexPath = indexPath
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
}

// MARK:- ScheduleDetailCellDelegate
extension StudentsScheduleViewController: ScheduleDetailCellDelegate {
    
    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath else {
            return
        }
        let dataSource = arrayDataSource[indexPath.section]
        guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail,
              let urlString = scheduleObj.scheduleURL,
              let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}



//MARK:- API CALL
extension StudentsScheduleViewController {
    func getScheduleDetails(to toDate:String, from fromDate:String){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "from_date" : fromDate,
            "to_date" : toDate
        ]
        if isParentsProfileFlow {
            manager.url = URLConstants.ParentsURL.parentsSchedule
            parameters["email"] = "axistesting@gmail.com"
            
        }else {
            manager.url = URLConstants.StudentURL.studentSchedule
            
        }

        manager.apiPostWithDataResponse(apiName: "Get Current Student Schedules", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
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

extension StudentsScheduleViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Schedule")
    }
}
