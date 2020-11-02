//
//  RepeatScheduleViewController.swift
//  TeachUs
//
//  Created by iOS on 28/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class RepeatScheduleViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var fromDate:Date?
    var toDate:Date?
    var classId:String?
    var scheduleDetails:ClassScheduleDetails?
    var flowType:AddUpdateType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(UINib(nibName: "ScheduleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)

        guard let fromDateObjs = fromDate, let toDate = toDate else {
            return
        }
        getScheduleDetails(between: fromDateObjs.getDateString(format: "YYYY-MM-dd"), toDate.getDateString(format: "YYYY-MM-dd"))
    }
    

}

extension RepeatScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.scheduleDetails?.schedules?.count ?? 0

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.scheduleDetails?.schedules?[section].scheduleDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScheduleDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.schdeduleDetailsCellId, for: indexPath)  as! ScheduleDetailsTableViewCell
        guard let scheduleObj = self.scheduleDetails?.schedules?[indexPath.section].scheduleDetails?[indexPath.row] else { return UITableViewCell() }
        cell.setUpCell(details: scheduleObj, cellType: .reschedule)
        cell.buttonEdit.indexPath = indexPath
        cell.buttonReschedule.indexPath = indexPath
        cell.delegate = self

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
        
    }
}

extension RepeatScheduleViewController: ScheduleDetailCellDelegate{
    
    func actionEditSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath,
              let scheduleObj = scheduleDetails?.schedules?[indexPath.section].scheduleDetails?[indexPath.row],
              let classId = scheduleObj.classId,
              let className = scheduleObj.className,
              let idString = scheduleObj.attendanceScheduleId,
              let id = Int(idString)
        else {
            return
        }
        let fromTime = scheduleObj.fromTime?.timeToDate(format: "HH:mm:ss")
        let toTime = scheduleObj.toTime?.timeToDate(format: "HH:mm:ss")
        let subject = ScheduleSubject(subjectId: scheduleObj.subjectId, subjectName: scheduleObj.subjectName)
        let professor = ScheduleProfessor(professorId: scheduleObj.professorId, professorName: scheduleObj.professorName, email: scheduleObj.professorEmail)
        let schdeulardDetails = SchedularData(date: Date(),
                                              fromTime: fromTime,
                                              toTime:toTime ,
                                              classId: classId,
                                              className: className,
                                              subject: subject,
                                              professor: professor,
                                              attendanceType: "Online",
                                              editScheduleId: id,
                                              flowType: self.flowType)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVc:AddNewScheduleViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.addNewScheduleId) as! AddNewScheduleViewController
        detailsVc.isScheduleEditing = true
        detailsVc.scheduleData = schdeulardDetails
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    
    func actionReschedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath, let schedule = self.scheduleDetails?.schedules?[indexPath.section].scheduleDetails?[indexPath.row] else {
            return
        }
        let okAction = {
            self.addNewSchedule(for: schedule)
        }
        let cancelAction = { }
        
        self.showAlertWithTitleAndCompletionHandlers(nil, alertMessage: "Are you sure you want to schdule this lecture?", okButtonString: "Schedule", canelString: "Cancel", okAction: okAction, cancelAction: cancelAction)
    }
    
    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        /*
         Abstract method, do nothing
         */
    }
    
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath) {
        /*
         Abstract method, do nothing
         */
    }
    
}


extension RepeatScheduleViewController {
    func getScheduleDetails(between fromDate:String, _ toDate:String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeScheduleDetails
        let parameters:[String:Any] = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : self.classId ?? "",
            "to_date" : toDate,
            "from_date" : fromDate ]
        
        manager.apiPostWithDataResponse(apiName: "Get College Schedules Details", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.scheduleDetails = try decoder.decode(ClassScheduleDetails.self, from: response)
                if !(self.scheduleDetails?.schedules?.isEmpty ?? true) {
                    self.tableView.reloadData()
                }else {
                    _ = { self.navigationController?.popViewController(animated: true) }
                    _ = {  }
                    self.showAlertWithTitleAndCompletionHandlers(nil, alertMessage: "No schedules available for selected date", okButtonString: "Ok", canelString: nil) {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: CollegeScheduleDetailsViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    } cancelAction: {
                        /* a strack method*/
                    }

                    
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

extension RepeatScheduleViewController {
    private func addNewSchedule(for scheduleData:ScheduleDetail) {
        guard let classId = self.classId else {
            return
        }

        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        
//        let scheduleParams:[String:Any] = [
//            "lecture_date": "\(Date().getDateString(format: "YYYY-MM-dd"))",
//            "from_time": "\(scheduleData.fromTime ?? "")",
//            "to_time": "\(scheduleData.toTime ?? "")",
//            "class_id": scheduleData.classId ?? "",
//            "class_name": scheduleData.className ?? "",
//            "subject_id" : scheduleData.subjectId ?? "",
//            "subject_name" : scheduleData.subjectName ?? "",
//            "professor_id" : "\(scheduleData.professorId ?? "")",
//            "professor_name" : "\(scheduleData.professorName ?? "")",
//            "professor_email" : "\(scheduleData.professorEmail ?? "")",
//            "attendance_type" : "\(scheduleData.attendanceType ?? "")"
//        ]
        
        
        var scheduleParams:[String:Any] = [
            "lecture_date": "\(Date().getDateString(format: "YYYY-MM-dd") )",
            "from_time": "\(scheduleData.fromTime ?? "")",
            "to_time": "\(scheduleData.toTime ?? "")",
            "class_id": "\(scheduleData.classId ?? "")",
            "class_name": "\(scheduleData.className ?? "")",
            "subject_id" : scheduleData.subjectId ?? "",
            "subject_name" : scheduleData.subjectName ?? "",
            "attendance_type" : "\(scheduleData.attendanceType ?? "")"
        ]
        
        if flowType == .collegeAdd || flowType == .collegeUpdate {
            manager.url = URLConstants.CollegeURL.addSchedule
            scheduleParams["professor_id"] = "\(scheduleData.professorId ?? "")"
            scheduleParams["professor_name"] = "\(scheduleData.professorName ?? "")"
            scheduleParams["professor_email"] = "\(scheduleData.professorEmail ?? "")"
        }
        
        if flowType == .professorAdd || flowType == .professorUpdate {
            manager.url = URLConstants.ProfessorURL.addSchedule
        }
        
        var requestString  =  ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: [scheduleParams],options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        
        var parameters: [String:Any] = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : classId,
            "schedule_list" : requestString
        ]
        
        if flowType == .collegeAdd {
            parameters["class_id"] = "\(classId)"
        }

        manager.apiPostWithDataResponse(apiName: "Add new schedule", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            if code == 200 {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String:Any]
                    let message = dictionary?["message"] as? String
                    let okAction: () -> () = {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: CollegeScheduleDetailsViewController.self) {
                                self.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                            if controller.isKind(of: ScheduleListViewController.self) {
                                self.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    let cancelAction: () -> () = { }
                    self.showAlertWithTitleAndCompletionHandlers("Success",
                                                                 alertMessage: message ?? "",
                                                                 okButtonString: "Ok",
                                                                 canelString: nil,
                                                                 okAction: okAction,
                                                                 cancelAction: cancelAction)
                }
                catch {
                }
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }

    }
}
