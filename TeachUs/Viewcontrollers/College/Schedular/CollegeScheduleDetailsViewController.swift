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
    var arrayDataSource = [ScheduleDetailDataSource]()
    var schedule : Schedule!
    
    let locale = NSLocale.current
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewScheduleDetails.register(UINib(nibName: "ScheduleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)
        tableviewScheduleDetails.register(UINib(nibName: "ScheduleDateTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)//AddNewScheduleTableViewCell
        tableviewScheduleDetails.register(UINib(nibName: "AddNewScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.collegeAddNewSchedule)

        tableviewScheduleDetails.dataSource = self
        tableviewScheduleDetails.delegate  = self
        tableviewScheduleDetails.estimatedRowHeight = 44.0
        tableviewScheduleDetails.rowHeight = UITableViewAutomaticDimension
        tableviewScheduleDetails.addSubview(refreshControl)
        getScheduleDetails(between: Date().getDateString(format: "YYYY-MM-DD"), Date().addDays(7).getDateString(format: "YYYY-MM-DD"))
    }
    
    
    
    func getScheduleDetails(between toDate:String, _ fromDate:String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeScheduleDetails
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : schedule.classId ?? "",
            "to_date" : toDate,
            "from_date" : fromDate
        ]
        
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
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let addbuttonDs = ScheduleDetailDataSource(detailsCell: .AddSchedule, detailsObject: nil)
        arrayDataSource.append(addbuttonDs)
        
        for schedule in self.scheduleDetails?.schedules ?? [] {
            let dateString = schedule.date?.getDateDisplayString()
            let dateDs = ScheduleDetailDataSource(detailsCell: .ScheduleDate, detailsObject: dateString)
            arrayDataSource.append(dateDs)
            
            for details in schedule.scheduleDetails ?? [] {
                let scheduleDS = ScheduleDetailDataSource(detailsCell: .SchdeuleDetails, detailsObject: details)
                arrayDataSource.append(scheduleDS)
            }
        }
        
        self.tableviewScheduleDetails.reloadData()
    }
    
    @IBAction func actionDatePicker(_ sender: Any) {
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        self.datePicker?.backgroundColor = UIColor.white
        self.datePicker?.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.center = view.center
        view.addSubview(self.datePicker)

        // ToolBar

        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        self.view.addSubview(toolBar)
        self.toolBar.isHidden = false

    }
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        //self.datePicker.resignFirstResponder()
        datePicker.isHidden = true
        self.toolBar.isHidden = true


    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true

    }

    
    
}

extension CollegeScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = arrayDataSource[indexPath.section]
        
        switch dataSource.cellType {
        case .AddSchedule:
            let cell:AddNewScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.collegeAddNewSchedule, for: indexPath)  as! AddNewScheduleTableViewCell
            cell.delegate = self
            
            return cell

        case .ScheduleDate:
            let cell:ScheduleDateTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.scheduleDetailsDateCellId, for: indexPath)  as! ScheduleDateTableViewCell
            let dateString = dataSource.attachedObject as? String ?? "NA"
            cell.labelDate.text = dateString
            return cell
            
        case .SchdeuleDetails:
            let cell:ScheduleDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.schdeduleDetailsCellId, for: indexPath)  as! ScheduleDetailsTableViewCell
            guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail else { return UITableViewCell() }
            cell.setUpCell(details: scheduleObj, cellType: .lectureDetails)
            cell.delegate = self
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableviewScheduleDetails.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
}

extension CollegeScheduleDetailsViewController: AddNewScheduleDelegate {
    func addNewSchdule() {
        #if DEBUG
        self.showAlertWithTitle("DEBUG MESSAGE", alertMessage: "Implement this: addNewSchdule")
        #endif
    }
}

extension CollegeScheduleDetailsViewController: ScheduleDetailCellDelegate{
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath) {
        #if DEBUG
        self.showAlertWithTitle("DEBUG MESSAGE", alertMessage: "Implement this: actionDeleteSchedule")
        #endif

    }
    
    func actionEditSchedule(_ sender: ButtonWithIndexPath) {
        #if DEBUG
        self.showAlertWithTitle("DEBUG MESSAGE", alertMessage: "Implement this: actionEditSchedule")
        #endif
    }
    
    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        #if DEBUG
        self.showAlertWithTitle("DEBUG MESSAGE", alertMessage: "Implement this: actionJoinSchedule")
        #endif
    }
    
    
}
