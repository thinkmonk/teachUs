//
//  ScheduleDetailsViewController.swift
//  TeachUs
//
//  Created by iOS on 31/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class ScheduleDetailsViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    var schedule : Schedule!
    var scheduleDetails:ClassScheduleDetails?
    private var currentToDate:String!
    private var currentFromDate:String!
    var arrayDataSource = [ScheduleDetailDataSource]()
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        view.backgroundColor = Constants.colors.backgroundColor
        tableview.register(UINib(nibName: "ScheduleDateTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.scheduleDetailsDateCellId)

        tableview.register(UINib(nibName: "ScheduleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.addSubview(refreshControl)

    }
    
    override func refresh(sender: AnyObject) {
        let toDate = currentToDate ?? Date().addDays(7).getDateString(format: "YYYY-MM-dd")
        let fromDate = currentFromDate ?? Date().getDateString(format: "YYYY-MM-dd")
        
        getScheduleDetails(to: toDate, from: fromDate)
        super.refresh(sender: sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh(sender: self)
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
        self.tableview.reloadData()
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

extension ScheduleDetailsViewController: DatePickerDelegate {
    func dateSelected(from fromDate: Date, to toDate: Date) {
        getScheduleDetails(to: toDate.getDateString(format: "YYYY-MM-dd"), from: fromDate.getDateString(format: "YYYY-MM-dd"))
    }
}


extension ScheduleDetailsViewController : UITableViewDelegate, UITableViewDataSource {
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
            cell.setUpCell(details: scheduleObj, cellType: scheduleObj.cellType)
            cell.buttonDelete.indexPath = indexPath
            cell.buttonEdit.indexPath = indexPath
            cell.buttonJoin.indexPath = indexPath
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableview.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

}
// MARK:- ScheduleDetailCellDelegate
extension ScheduleDetailsViewController: ScheduleDetailCellDelegate {
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath else {
            return
        }
        
        
        let dataSource = arrayDataSource[indexPath.section]
        guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail else { return }
        self.showAlertWithTitleAndCompletionHandlers("Delete Schedule!",
                                                     alertMessage: "Are you sure you want to delete this schedule",
                                                     okButtonString: "YES",
                                                     canelString: "CANCEL",
                                                     okAction: { self.deleteSchedule(for: scheduleObj) },
                                                     cancelAction: {} )
    }
    
    func actionEditSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath else {
            return
        }
        
        let dataSource = arrayDataSource[indexPath.section]
        guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail,
              let classId = scheduleObj.classId,
              let className = scheduleObj.className,
              let idString = scheduleObj.attendanceScheduleId,
              let id = Int(idString)  else { return }
        let fromTime = scheduleObj.fromTime?.timeToDate(format: "HH:mm:ss")
        let toTime = scheduleObj.toTime?.timeToDate(format: "HH:mm:ss")
        let subject = ScheduleSubject(subjectId: scheduleObj.subjectId, subjectName: scheduleObj.subjectName)
        let professor = ScheduleProfessor(professorId: scheduleObj.professorId, professorName: scheduleObj.professorName, email: scheduleObj.professorEmail)
        let schdeulardDetails = SchedularData(date: scheduleObj.lectureDate?.convertToDate("YYYY-MM-dd"),//2020-10-16
                                              fromTime: fromTime,
                                              toTime:toTime ,
                                              classId: classId,
                                              className: className,
                                              subject: subject,
                                              professor: professor,
                                              attendanceType: "Online",
                                              editScheduleId: id,
                                              flowType: .professorUpdate)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVc:AddNewScheduleViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.addNewScheduleId) as! AddNewScheduleViewController
        detailsVc.scheduleData = schdeulardDetails
        detailsVc.isScheduleEditing = true
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    
    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath,
              let schedule = arrayDataSource[indexPath.section].attachedObject as? ScheduleDetail,
              let scheduleURL = schedule.scheduleHostURL,
              let url = URL(string: scheduleURL) else {
            return
        }
        UIApplication.shared.open(url)
    }

}


//MARK:- API CALL

extension ScheduleDetailsViewController {
    func getScheduleDetails(to toDate:String, from fromDate:String) {
        self.currentToDate = toDate
        self.currentFromDate = fromDate
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.professorScheduleDetails
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : schedule.classId ?? "",
            "subject_id": schedule.subjectId ?? "",
            "to_date" : toDate,
            "from_date" : fromDate
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get Professor Schedules Details", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
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
    
    func deleteSchedule(for schedule: ScheduleDetail) {
        guard let scheduleId = schedule.attendanceScheduleId,
              let deleteFlagString = schedule.deleteFlag,
              let deleteFlag = Int(deleteFlagString) else {
            return
        }
        let manager = NetworkHandler()
        
        manager.url = deleteFlag.boolValue ? URLConstants.ProfessorURL.scheduleDelete : URLConstants.ProfessorURL.scheduleRejectRequest
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "attendance_schedule_id" : scheduleId
        ]
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiPostWithDataResponse(apiName: "Delete Schedule", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self,
                let toDate = self.currentToDate,
                let fromDate = self.currentFromDate
                else { return }
            
            if code == 200 {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String:Any]
                    let message = dictionary?["message"] as? String
                    self.showAlertWithTitle("Success", alertMessage: message ?? "")
                }
                catch let error{
                    print(error.localizedDescription)
                }
            }
            
            self.getScheduleDetails(to: toDate, from: fromDate)
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
}
