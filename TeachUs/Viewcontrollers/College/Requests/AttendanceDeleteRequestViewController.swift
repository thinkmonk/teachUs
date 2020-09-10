//
//  AttendanceDeleteRequestViewController.swift
//  TeachUs
//
//  Created by iOS on 30/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

protocol DeleteRequestDelegate:class {
    func updateRequestData(_ isApproved:Bool, requestType:ChangeRequestType, id requestId: Int)
}


class AttendanceDeleteRequestViewController: BaseViewController {
    
    @IBOutlet weak var tableviewDeleteLog: UITableView!
    var logDetails:LogArray!
    var arrayDataSource = [DeleteAttendanceLogDataSource]()
    weak var delegate:DeleteRequestDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewDeleteLog.delegate = self
        tableviewDeleteLog.dataSource = self
        tableviewDeleteLog.separatorStyle = .none
        tableviewDeleteLog.register(UINib(nibName: "LogsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId)
        tableviewDeleteLog.register(UINib(nibName: "SyllabusDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId)
        tableviewDeleteLog.register(UINib(nibName: "CustomKeyValueTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.customKeyValueTableViewCellId)
        tableviewDeleteLog.register(UINib(nibName: "CustomButtonsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.customAcceptRejectTableviewcellId)
        
        tableviewDeleteLog.estimatedRowHeight = 40
        tableviewDeleteLog.rowHeight = UITableViewAutomaticDimension
        tableviewDeleteLog.backgroundColor = .clear
        makeDataSource()
        
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let typeDs = DeleteAttendanceLogDataSource(celType: .UserType, attachedObject: logDetails.userType)
        arrayDataSource.append(typeDs)
        
        
        let nameDs = DeleteAttendanceLogDataSource(celType: .UserName, attachedObject: logDetails.professorName)
        arrayDataSource.append(nameDs)
        
        let requestDs = DeleteAttendanceLogDataSource(celType: .RequestType, attachedObject: logDetails.requestType)
        arrayDataSource.append(requestDs)
        
        let classDs = DeleteAttendanceLogDataSource(celType: .RequestClass, attachedObject: logDetails.courseName)
        arrayDataSource.append(classDs)
        
        let subjectDs = DeleteAttendanceLogDataSource(celType: .RequestSubject, attachedObject: logDetails.subjectName)
        arrayDataSource.append(subjectDs)
        
        let reasonDs = DeleteAttendanceLogDataSource(celType: .Reason, attachedObject: logDetails.comment)
        arrayDataSource.append(reasonDs)
        
        let logHeaderDs = DeleteAttendanceLogDataSource(celType: .logHeader, attachedObject: "")
        arrayDataSource.append(logHeaderDs)
        
        
        let detailsDataSource = DeleteAttendanceLogDataSource(celType: .LogDetails, attachedObject: logDetails)
        self.arrayDataSource.append(detailsDataSource)
        
        for unit in logDetails.unitList ?? [] {
            for topic in unit.topicList{
                topic.unitId = unit.unitId
                topic.unitName = unit.unitName
                let syllabusDatasource = DeleteAttendanceLogDataSource(celType: .SyllabusDetail, attachedObject: topic)
                self.arrayDataSource.append(syllabusDatasource)
            }
        }
        
        
        let buttonDs = DeleteAttendanceLogDataSource(celType: .ApproveOrRejectButton, attachedObject: nil)
        arrayDataSource.append(buttonDs)
        
        tableviewDeleteLog.reloadData()
    }
    
    @objc func approve() {
        self.dismiss(animated: true) {
            guard let attendanceId = self.logDetails.deleteRequestAttId, let id = Int(attendanceId) else { return }
            self.delegate?.updateRequestData(true, requestType: .DeleteAttendance, id: id)
        }
    }
    
    @objc func reject() {
        self.dismiss(animated: true) {
            guard let attendanceId = self.logDetails.deleteRequestAttId, let id = Int(attendanceId) else { return }
            self.delegate?.updateRequestData(false, requestType: .DeleteAttendance, id: id)
        }
    }
    
}

extension AttendanceDeleteRequestViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = arrayDataSource[indexPath.section]
        
        switch dataSource.logsCellType {
        case .LogDetails:
            guard let logs = dataSource.attachedObject as? LogArray else { return UITableViewCell() }
            let cell:LogsDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LogsDetailTableViewCellId, for: indexPath) as! LogsDetailTableViewCell
            cell.labelNumberOfLecs.text = logs.noOfLecture
            cell.labelAttendanceCount.text = logs.totalStudentAttendance
            cell.labelLectureTime.text = "\(logs.fromTime ?? "") to \(logs.toTime ?? "")"
            cell.viewTimeOfSubject.alpha = 1
            cell.labelDate.text = "\(logs.lectureDate ?? "")"
            cell.labelTimeOfSubmission.text = "\(logs.dateOfSubmission ?? "")"
            cell.selectionStyle = .none
            cell.viewHeader.isHidden = true
            cell.layoutHeaderHeight.constant = 0
            cell.layoutTopViewHeight.constant = 0
            cell.backgroundColor = .clear
            return cell
            
        case .SyllabusDetail:
            guard let chapterAttached = dataSource.attachedObject as? TopicList else { return UITableViewCell()}
            let cell:SyllabusDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId, for: indexPath) as! SyllabusDetailsTableViewCell
            cell.imageViewStatus.alpha = 0
            cell.labelChapterNumber.text = "\(chapterAttached.unitName ?? "NA")"
            cell.labelChapterDetails.text = "\(chapterAttached.topicName ?? "NA")"
            cell.viewSeperator.alpha = 0
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
            
        case .UserType,
             .UserName,
             .RequestType,
             .RequestClass,
             .RequestSubject,
             .Reason,
             .logHeader:
            let cell:CustomKeyValueTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.customKeyValueTableViewCellId, for: indexPath) as! CustomKeyValueTableViewCell
            cell.labelCustomKey.text = dataSource.logsCellType?.keyName ?? "NA"
            cell.labelCustomValue.text = dataSource.attachedObject as? String ?? "NA"
            cell.backgroundColor = .clear
            
            return cell
            
        case .ApproveOrRejectButton:
            let cell:CustomButtonsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.customAcceptRejectTableviewcellId) as! CustomButtonsTableViewCell
            cell.buttonApprove.addTarget(self, action:  #selector(approve), for: .touchUpInside)
            cell.buttonReject.addTarget(self, action:  #selector(reject), for: .touchUpInside)
            cell.backgroundColor = .clear
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellDataSource = arrayDataSource[indexPath.section]
        switch cellDataSource.logsCellType! {
        case .LogDetails:
            return 110
        
        case .SyllabusDetail:
            return 80
            
        default: return UITableViewAutomaticDimension
        }
    }
}
