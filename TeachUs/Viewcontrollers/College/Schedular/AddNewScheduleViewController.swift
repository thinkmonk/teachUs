//
//  AddNewScheduleViewController.swift
//  TeachUs
//
//  Created by iOS on 17/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

enum LectureMode:String,CaseIterable {
    case online = "Online"
    case offline = "Offline"
}

struct SchedularData {
    var date: Date? = nil
    var fromTime: Date?  = nil
    var toTime: Date? = nil
    var classId: String?
    var className: String?
    var subject: ScheduleSubject? = nil
    var professor: ScheduleProfessor? = nil
    var attendanceType: String? = nil
    var editScheduleId: Int?
    var flowType: AddUpdateType
    var platformType: String? = nil
    var platformName: String? = nil
    var scheduleLink: String? = nil
    var zoomEmail: SchedulesProfile?
    var isPlatformSelectionValid: Bool {
        if let platform = platformType, platform == "1" { //if the platform selected is zoom then validate wether the zoomid is selcted or
            return zoomEmail != nil

        }
        return platformType != nil
    }
    
    var isNotNil : Bool {
        switch flowType {
        case .collegeAdd, .collegeUpdate:
            return date != nil &&
                fromTime != nil &&
                toTime != nil &&
                subject != nil &&
                professor != nil &&
                attendanceType != nil &&
                isPlatformSelectionValid
            
        case .professorAdd, .professorUpdate:
            return date != nil &&
                fromTime != nil &&
                toTime != nil &&
                subject != nil &&
                attendanceType != nil &&
                isPlatformSelectionValid
        }
    }
}

enum AddUpdateType {
    case collegeAdd
    case collegeUpdate
    case professorAdd
    case professorUpdate
}

enum PickerTag:Int, CaseIterable {
    case RepeatSchedule
    case Date
    case FromTime
    case ToTime
    case SubjectName
    case ProfessorName
    case Mode
    case ModePlatform
    case ModeLink
    case ZoomId
    
    var title:String {
        switch self {
        case .RepeatSchedule : return "Repeat Schedule"
        case .Date : return "Date"
        case .FromTime : return "From Time"
        case .ToTime : return "To Time"
        case .SubjectName : return "Subject Name"
        case .ProfessorName : return "Professor Name"
        case .Mode : return "Mode"
        case .ModePlatform : return "Platform"
        case .ModeLink : return "Link"
        case .ZoomId : return "Zoom Id"
        }
    }
}

class AddNewScheduleDataSource {
    var cellType:PickerTag!
    var selectedObj:Any?
    var attachedObject:Any?
    
    init(detailsCell:PickerTag, detailsObject:Any?) {
        self.cellType = detailsCell
        self.attachedObject = detailsObject
    }
}

class AddNewScheduleViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var buttonAddSchedule: UIButton!
    private var subjectList:ScheduleSubjectList!
    private var professorList:ScheduleProfessorList!
    private var repeatScheduleDataSource = [RescheduleWeeks]()
    private var selectedScheduleWeek : RescheduleWeeks? = nil
    private var rescheduleFlowType : RescheduleFlowType? = nil

    private var modeDataSource: [String] {
        return LectureMode.allCases.map({$0.rawValue})
    }
    
//    var classId:String!
//    var className:String!
    private var arrayDataSource = [AddNewScheduleDataSource]()
    private var activeTextField:CustomTextField!
    private var toolBar = UIToolbar()
    private var scheduleModeData:ScheduleModeType?
    private var zoomProfiles:ScheduleProfiles?

    private let picker = UIPickerView()
    private var datepicker = UIDatePicker()
    var scheduleData : SchedularData!
    var isScheduleEditing:Bool = false

    
    enum RescheduleFlowType {
        case date
        case week
    }
    
//MARK:-  Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToNavBar()
        tableview.register(UINib(nibName: "ScheduleTextTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.addScheduleCell)
        tableview.register(UINib(nibName: "RepeatScheduleOptionTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.scheduleOptionsCellId)
        
        tableview.estimatedRowHeight = 44
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.separatorStyle = .none
        buttonAddSchedule.themeRedButton()
        buttonAddSchedule.isHidden = !scheduleData.isNotNil
        getScheduleSubject()
        if let scheduleType = self.scheduleData.platformType, !scheduleType.isEmpty {
            getScheduleModes()
        }
        setUpToolBar()
        setUpKeyboardObservers()
    }
    
    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

        
    func setUpToolBar() {
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self

        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    func showRepeatScheduleView(from dateFrom:Date, to dateTo:Date) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewContoller:RepeatScheduleViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.repeatScheduleList) as! RepeatScheduleViewController
        destinationViewContoller.fromDate = dateFrom
        destinationViewContoller.toDate = dateTo
        destinationViewContoller.classId = self.scheduleData.classId
        destinationViewContoller.flowType = self.scheduleData.flowType
        self.navigationController?.pushViewController(destinationViewContoller, animated: true)
    }
    
    @objc func donePicker() {
        guard  let textField = activeTextField, let indexPath = textField.indexpath else {
            switch self.rescheduleFlowType {
            case .date:
                toolBar.removeFromSuperview()
                datepicker.removeFromSuperview()
                self.showRepeatScheduleView(from: datepicker.date, to: datepicker.date)

            case .week:
                guard let startDate = selectedScheduleWeek?.startDate,
                      let endDate = selectedScheduleWeek?.endDate else {
                    return
                }
                picker.removeFromSuperview()
                toolBar.removeFromSuperview()
                self.showRepeatScheduleView(from: startDate, to: endDate)
                
            case .none:
                break
            }
            
//            guard let startDate = selectedScheduleWeek?.startDate,
//                  let endDate = selectedScheduleWeek?.endDate else {
//                toolBar.removeFromSuperview()
//                datepicker.removeFromSuperview()
//                self.showRepeatScheduleView(from: datepicker.date, to: datepicker.date)
//                return
//            }
//
            return
        }
        
        let dataSource = arrayDataSource[indexPath.section]
        
        switch dataSource.cellType {
        case .Date:
            scheduleData.date = datepicker.date
            validateAndReloadTable(row: indexPath.section)
            
        case .FromTime:
            scheduleData.fromTime = datepicker.date
            validateAndReloadTable(row: indexPath.section)
            
        case .ToTime:
            scheduleData.toTime = datepicker.date
            validateAndReloadTable(row: indexPath.section)
            
        case .SubjectName:
            guard let subject = scheduleData.subject else { break }
            scheduleData.professor = nil
            self.zoomProfiles = nil
            if self.scheduleData.flowType == .collegeAdd || self.scheduleData.flowType == .collegeUpdate {
                self.getScheduleProfessor(for: subject)
            }else {
                tableview.reloadData()
            }
            
        case .ProfessorName:
            self.scheduleData.zoomEmail = nil
            self.zoomProfiles = nil //professor and zoom profiles are linked so reset them when the professor is chaged
            validateAndReloadTable(row: indexPath.section)
            makeDataSource()
            
        case .Mode:
            self.scheduleData.zoomEmail = nil
            self.zoomProfiles = nil
            validateAndReloadTable(row: indexPath.section)
            self.makeDataSource()
            
        case .ModePlatform:
            guard let platform = scheduleData.platformType else { break }
            scheduleData.zoomEmail = nil
            self.zoomProfiles = nil
            if platform == "1" {
                if self.scheduleData.flowType == .collegeAdd || self.scheduleData.flowType == .collegeUpdate {
                    if  let professorId = scheduleData.professor?.professorId {
                        self.getProfessorZoomId(with: professorId)
                    }
                }else {
                    self.getProfessorZoomId()
                }
            }else {
                self.makeDataSource()
                validateAndReloadTable(row: indexPath.section)
            }
            
        default:
            validateAndReloadTable(row: indexPath.section)
        }

        activeTextField.resignFirstResponder()
    }
    
    func makeDataSource() {
        buttonAddSchedule.isHidden = !scheduleData.isNotNil
        arrayDataSource.removeAll()
        
        if !isScheduleEditing {
            let repeatDS = AddNewScheduleDataSource(detailsCell: .RepeatSchedule, detailsObject: nil)
            arrayDataSource.append(repeatDS)
        }
        
        let dateDs = AddNewScheduleDataSource(detailsCell: .Date, detailsObject: nil)
        arrayDataSource.append(dateDs)
        
        let fromTimeDs = AddNewScheduleDataSource(detailsCell: .FromTime, detailsObject: nil)
        arrayDataSource.append(fromTimeDs)
        
        let toTimeDs = AddNewScheduleDataSource(detailsCell: .ToTime, detailsObject: nil)
        arrayDataSource.append(toTimeDs)
        
        let subjectName = AddNewScheduleDataSource(detailsCell: .SubjectName, detailsObject: subjectList)
        arrayDataSource.append(subjectName)
        
        if !(professorList?.scheduleProfessor?.isEmpty ?? true) && (scheduleData.flowType == .collegeAdd || scheduleData.flowType == .collegeUpdate) {
            if self.professorList != nil {
                let professorName = AddNewScheduleDataSource(detailsCell: .ProfessorName, detailsObject: professorList)
                arrayDataSource.append(professorName)
            }else{
                if let subject = scheduleData.subject {
                    self.getScheduleProfessor(for: subject)
                }
            }
        }
        
        let modeDs = AddNewScheduleDataSource(detailsCell: .Mode, detailsObject: nil)
        arrayDataSource.append(modeDs)
        
        
        if let mode = scheduleData.attendanceType, !mode.isEmpty, mode == LectureMode.online.rawValue {
            if (self.scheduleModeData != nil){
                let platform = AddNewScheduleDataSource(detailsCell: .ModePlatform, detailsObject: nil)
                arrayDataSource.append(platform)
            }else{
                getScheduleModes()
            }
            
            if let platform = scheduleData.platformType, platform == "1" {//1: Zoom, 2: Google meet, 3: Microsoft teams
                
                if self.scheduleData.flowType == .collegeAdd || self.scheduleData.flowType == .collegeUpdate {
                    
                    if !(professorList?.scheduleProfessor?.isEmpty ?? true) { //proceed only if professor is selected
                        
                        if zoomProfiles != nil { //proceed only if zoom profiles are availble else fetch them
                            let link = AddNewScheduleDataSource(detailsCell: .ZoomId, detailsObject: nil)
                            arrayDataSource.append(link)
                        }else{
                            if let professorId = scheduleData.professor?.professorId {
                                self.getProfessorZoomId(with: professorId)
                            }
                        }
                    }
                }else{
                    if zoomProfiles != nil {
                        let link = AddNewScheduleDataSource(detailsCell: .ZoomId, detailsObject: nil)
                        arrayDataSource.append(link)
                    }else{
                        self.getProfessorZoomId()
                    }
                }
            }
            if let platform = scheduleData.platformType, platform == "2" {
                let link = AddNewScheduleDataSource(detailsCell: .ModeLink, detailsObject: nil)
                arrayDataSource.append(link)
                
            }
        }
        
        self.tableview.reloadData()
    }
    
    @IBAction func actionAdd(_ sender: Any) {        
        switch scheduleData.flowType {
        case .collegeAdd,
             .professorAdd:
            addNewSchedule()
            
        case .collegeUpdate,
             .professorUpdate:
            updateSchedule()
        }
        
    }
    
}


//MARK:- Table view methods
extension AddNewScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = arrayDataSource[indexPath.section] as AddNewScheduleDataSource
        let cell:ScheduleTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.addScheduleCell, for: indexPath)  as! ScheduleTextTableViewCell
        
        cell.labelTitle.text = dataSource.cellType.title
        cell.textFieldValue.placeholder = dataSource.cellType.title
        
        cell.textFieldValue.tag = dataSource.cellType.rawValue
        cell.textFieldValue.indexpath = indexPath
        cell.textFieldValue.delegate = self
        cell.selectionStyle = .none
        switch dataSource.cellType {
        case .RepeatSchedule:
            let cell:RepeatScheduleOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.scheduleOptionsCellId, for: indexPath)  as! RepeatScheduleOptionTableViewCell
            cell.labelTitle.text = dataSource.cellType.title
            cell.delegate = self
            return cell
            
        case .Date:
            cell.textFieldValue.text = scheduleData.date?.getDateString(format: "dd MMMM yyyy") ?? ""
            
        case .FromTime:
            cell.textFieldValue.text = scheduleData.fromTime?.getDateString(format: "h:mm a") ?? ""
            
        case .ToTime:
            cell.textFieldValue.text = scheduleData.toTime?.getDateString(format: "h:mm a") ?? ""
            
        case .SubjectName:
            cell.textFieldValue.text = scheduleData.subject?.subjectName ?? ""
            
        case .ProfessorName:
            if let selectedProfessor = scheduleData.professor {
                cell.textFieldValue.text = selectedProfessor.professorName ?? ""
            } else {
                cell.textFieldValue.text = ""
            }
            
        case .Mode:
            cell.textFieldValue.text = scheduleData.attendanceType ?? ""
            
        case .ModePlatform:
            cell.textFieldValue.text = scheduleData.platformName ?? ""
            
            
        case .ModeLink:
            cell.textFieldValue.text = scheduleData.scheduleLink ?? ""
            
        case .ZoomId:
            if let object = scheduleData.zoomEmail, let email = object.email {
                cell.textFieldValue.text = email
            }else {
                cell.textFieldValue.text = ""
            }
        default:
            cell.textFieldValue.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableview.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

}

//MARK:- Picker view methods
extension AddNewScheduleViewController:UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard  let textField = textField as? CustomTextField, let indexPath = textField.indexpath else {
            return
        }
        activeTextField = textField
        activeTextField.tag = -1
        let dataSource = arrayDataSource[indexPath.section]
        
        switch dataSource.cellType {
        case .Date:
            datepicker.datePickerMode = .date
            datepicker.minimumDate = Date()
            datepicker.tag = dataSource.cellType.rawValue
            textField.inputView = datepicker
            textField.inputAccessoryView = toolBar
            
        case .FromTime:
            datepicker.datePickerMode = .time
            datepicker.date = scheduleData.fromTime ?? Date()
            datepicker.tag = dataSource.cellType.rawValue
            textField.inputView = datepicker
            textField.inputAccessoryView = toolBar
            datepicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            
        case .ToTime:
            datepicker.datePickerMode = .time
            datepicker.date = scheduleData.toTime ?? Date()
            textField.inputView = datepicker
            datepicker.tag = dataSource.cellType.rawValue
            textField.inputAccessoryView = toolBar
            datepicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            
        case .ModeLink:
            activeTextField.tag = dataSource.cellType.rawValue
            break
            
        default:
            textField.inputView = picker
            textField.inputAccessoryView = toolBar
            picker.tag = dataSource.cellType.rawValue
            picker.reloadAllComponents()
            self.pickerView(self.picker, didSelectRow: 0, inComponent: 0)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField.tag == PickerTag.ModeLink.rawValue {
            scheduleData.scheduleLink = activeTextField.text
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case PickerTag.SubjectName.rawValue:
            return self.subjectList.scheduleSubject?.count ?? 0
            
        case PickerTag.ProfessorName.rawValue:
            return self.professorList.scheduleProfessor?.count ?? 0
            
        case PickerTag.Mode.rawValue:
            return self.modeDataSource.count
            
        case PickerTag.RepeatSchedule.rawValue:
            return self.repeatScheduleDataSource.count
            
        case PickerTag.ModePlatform.rawValue:
            return self.scheduleModeData?.scheduleModes?.count ?? 0
            
        case PickerTag.ZoomId.rawValue:
            return self.zoomProfiles?.arraySchedulesProfile?.count ?? 0
            
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let dataSource = arrayDataSource[pickerView.tag]
        
        switch pickerView.tag {
        case PickerTag.SubjectName.rawValue:
            scheduleData.subject = subjectList.scheduleSubject?[row]
            if scheduleData.flowType == .professorAdd || scheduleData.flowType == .professorUpdate {
                scheduleData.classId = scheduleData.subject?.classId ?? ""
                scheduleData.className = scheduleData.subject?.className ?? ""
            }
        case PickerTag.ProfessorName.rawValue:
            scheduleData.professor = professorList.scheduleProfessor?[row]
            
        case PickerTag.Mode.rawValue:
            scheduleData.attendanceType = modeDataSource[row]
            
        case PickerTag.RepeatSchedule.rawValue:
            selectedScheduleWeek = repeatScheduleDataSource[row]
            
        case PickerTag.ModePlatform.rawValue:
            scheduleData.platformType = self.scheduleModeData?.scheduleModes?[row].scheduleType ?? ""
            scheduleData.platformName = self.scheduleModeData?.scheduleModes?[row].name ?? ""
            
        case PickerTag.ZoomId.rawValue:
            scheduleData.zoomEmail = self.zoomProfiles?.arraySchedulesProfile?[row]
            
        default: break
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if view == nil {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: UIFont.systemFont(ofSize: UIFont.systemFontSize).lineHeight * 2 * UIScreen.main.scale))
            label.textAlignment = .center
            label.numberOfLines = 0
            label.autoresizingMask = .flexibleWidth
        } else {
            label = view as! UILabel
        }
        label.text = getLabelText(for: row, with: pickerView.tag)
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize).lineHeight * 2 * UIScreen.main.scale
   }
    
    func validateAndReloadTable(row:Int) {
        buttonAddSchedule.isHidden = !scheduleData.isNotNil
        let indexpath = IndexPath(row: 0, section: row)
        self.tableview.reloadRows(at: [indexpath], with: .fade)
    }
    
    func getLabelText(for row:Int, with tag:Int) -> String {
        switch tag {
        case PickerTag.SubjectName.rawValue:
            let subjectName = self.subjectList.scheduleSubject?[row].subjectName ?? ""
            let className = self.subjectList.scheduleSubject?[row].className ?? ""
            return "\(subjectName) - \(className)"
            
        case PickerTag.ProfessorName.rawValue:
            return self.professorList.scheduleProfessor?[row].professorName ?? "NA"
            
        case PickerTag.Mode.rawValue:
            return self.modeDataSource[row]
            
        case PickerTag.RepeatSchedule.rawValue:
            guard let startDate =  self.repeatScheduleDataSource[row].startDate,
                  let endDate = self.repeatScheduleDataSource[row].endDate else {
                return ""
            }
            let week = "Week \(row+1): "
            let dates = "\(startDate.getDateString(format: "MMM-dd")) to \(endDate.getDateString(format: "MMM-dd"))"
            return week + dates
            
        case PickerTag.ModePlatform.rawValue: return self.scheduleModeData?.scheduleModes?[row].name ?? ""
            
        case PickerTag.ZoomId.rawValue:
            return self.zoomProfiles?.arraySchedulesProfile?[row].email ?? ""
            
        default: return "NA"
        }
    }
    
}

//MARK:- API Calls
extension AddNewScheduleViewController {
    
    private func getScheduleSubject() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        var parameters:[String:Any] = [String:Any]()
        
        switch scheduleData.flowType {
        case .collegeUpdate, .collegeAdd:
            manager.url = URLConstants.CollegeURL.getScheduleSubject
            parameters["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
            parameters["class_id"] = "\(scheduleData.classId ?? "")"

            
        case .professorUpdate,.professorAdd:
            manager.url = URLConstants.ProfessorURL.getScheduleSubject
            parameters["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        }
        
        manager.apiPostWithDataResponse(apiName: "Get Schedule Class", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.subjectList = try decoder.decode(ScheduleSubjectList.self, from: response)
            } catch let error{
                print("err", error)
            }
            guard let subject =  self.scheduleData.subject else {
                self.makeDataSource()
                return
            }
            if self.scheduleData.flowType == .collegeAdd || self.scheduleData.flowType == .collegeUpdate {
                self.getScheduleProfessor(for: subject)
            }else {
                self.makeDataSource()
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    private func getScheduleProfessor(for subject:ScheduleSubject) {
        guard let subjectId = subject.subjectId else {
            return
        }
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getScheduleProfessor
        
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : "\(scheduleData.classId ?? "")",
            "subject_id": "\(subjectId)"
        ]
        manager.apiPostWithDataResponse(apiName: "Get Professor for subject", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.professorList = try decoder.decode(ScheduleProfessorList.self, from: response)
            } catch let error{
                print("err", error)
            }
            self.makeDataSource()
        }) {  (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    private func getScheduleModes() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getScheduleType
        
        manager.apiGetWithDataResponse(apiName: "get all schedule modes", completionHandler: { [weak self] (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.scheduleModeData = try decoder.decode(ScheduleModeType.self, from: response)
                self.scheduleData.platformName = self.scheduleModeData?.scheduleModes?.first(where: {$0.scheduleType == self.scheduleData.platformType})?.name ?? ""
            } catch let error{
                print("err", error)
            }
            self.makeDataSource()
            
        }, failure: { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            
        })
    }
    
    private func getProfessorZoomId(with professorId:String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getZoomEmails
        
        let parameters:[String:Any] = [
            "class_id": "\(scheduleData.classId ?? "")",
            "professor_id" : "\(scheduleData.professor?.professorId ?? "")",
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code ?? "")"
        ]

        manager.apiPostWithDataResponse(apiName: "get all zoom email for id \(professorId)", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.zoomProfiles = try decoder.decode(ScheduleProfiles.self, from: response)
                self.makeDataSource()
            } catch let error{
                print("err", error)
            }
            self.makeDataSource()
            
        }, failure: { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        })
    }
    
    private func getProfessorZoomId() {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getZoomEmails
        
        let parameters:[String:Any] = [
            "class_id": "\(scheduleData.classId ?? "")",
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code ?? "")"
        ]

        manager.apiPostWithDataResponse(apiName: "get all zoom email for id professor", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.zoomProfiles = try decoder.decode(ScheduleProfiles.self, from: response)
                self.makeDataSource()
            } catch let error{
                print("err", error)
            }
            self.makeDataSource()
            
        }, failure: { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        })
    }

    
    private func addNewSchedule() {
        guard scheduleData.isNotNil else {
            return
        }
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        
        
        var scheduleParams:[String:Any] = [
            "lecture_date": "\(scheduleData.date?.getDateString(format: "YYYY-MM-dd") ?? "")",
            "from_time": "\(scheduleData.fromTime?.getDateString(format: "HH:mm:ss") ?? "")",
            "to_time": "\(scheduleData.toTime?.getDateString(format: "HH:mm:ss") ?? "")",
            "class_id": "\(scheduleData.classId ?? "")",
            "class_name": "\(scheduleData.className ?? "")",
            "subject_id" : scheduleData.subject?.subjectId ?? "",
            "subject_name" : scheduleData.subject?.subjectName ?? "",
            "attendance_type" : "\(scheduleData.attendanceType ?? "")",
            "schedule_type" : "\(scheduleData.platformType ?? "")",
            "schedule_url" : "\(scheduleData.scheduleLink ?? "")",
            "schedule_profile_details_id" : "\(scheduleData.zoomEmail?.scheduleProfileDetailsId ?? "")"

        ]

        if scheduleData.flowType == .collegeAdd {
            manager.url = URLConstants.CollegeURL.addSchedule
            scheduleParams["professor_id"] = "\(scheduleData.professor?.professorId ?? "")"
            scheduleParams["professor_name"] = "\(scheduleData.professor?.professorName ?? "")"
            scheduleParams["professor_email"] = "\(scheduleData.professor?.email ?? "")"
        }
        
        if scheduleData.flowType == .professorAdd {
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
            "schedule_list" : requestString
        ]
        
        if scheduleData.flowType == .collegeAdd {
            parameters["class_id"] = "\(scheduleData.classId ?? "")"
        }
        //apiPostWithDataResponse apiPostResponseString
        manager.apiPostWithDataResponse(apiName: "Add new schedule", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            if code == 200 {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String:Any]
                    let message = dictionary?["message"] as? String
                    guard let status = dictionary?["status"] as? Int else {
                        return
                    }
                    if status == 200 {
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
                    }else{
                        self.showAlertWithTitle("Error", alertMessage: message ?? "")
                    }
                }
                catch let error{
                    print(error.localizedDescription)
                }
            }
            self.makeDataSource()
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    private func updateSchedule() {
        guard scheduleData.isNotNil else {
            return
        }
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        let manager = NetworkHandler()
        
        var scheduleParams:[String:Any] = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id": "\(scheduleData.classId ?? "")",
            "subject_id" : scheduleData.subject?.subjectId ?? "",
            "from_time": "\(scheduleData.fromTime?.getDateString(format: "HH:mm:ss") ?? "")",
            "to_time": "\(scheduleData.toTime?.getDateString(format: "HH:mm:ss") ?? "")",
            "lecture_date": "\(scheduleData.date?.getDateString(format: "YYYY-MM-dd") ?? "")",
            "attendance_schedule_id" : "\(scheduleData.editScheduleId ?? 0)",
            "attendance_type" : "\(scheduleData.attendanceType ?? "")",
            "subject_name" : scheduleData.subject?.subjectName ?? "",
            "class_name":"\(scheduleData.className ?? "")",
            "schedule_type" : "\(scheduleData.platformType ?? "")",
            "schedule_url" : "\(scheduleData.scheduleLink ?? "")",
            "schedule_profile_details_id" : "\(scheduleData.zoomEmail?.scheduleProfileDetailsId ?? "")"
        ]
        
        if scheduleData.flowType == .collegeUpdate {
            manager.url = URLConstants.CollegeURL.updateSchedule
            scheduleParams["professor_id"] = "\(scheduleData.professor?.professorId ?? "")"
            scheduleParams["professor_name"] = "\(scheduleData.professor?.professorName ?? "")"
            scheduleParams["professor_email"] = "\(scheduleData.professor?.email ?? "")"
            scheduleParams["schedule_profile_mail"] = "\(scheduleData.zoomEmail?.email ?? "")"

        }
        
        if scheduleData.flowType == .professorUpdate {
            manager.url = URLConstants.ProfessorURL.updateSchedule
        }
        
        
        manager.apiPostWithDataResponse(apiName: "update schedule", parameters:scheduleParams, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            if code == 200 {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [String:Any]
                    let message = dictionary?["message"] as? String
                    let okAction: () -> () = {
                        self.navigationController?.popViewController(animated: true)
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
            self.makeDataSource()
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
}

extension AddNewScheduleViewController : RepeatScheduleDelegate{
    func actionDay() {
        rescheduleFlowType = .date
        picker.removeFromSuperview()
        toolBar.removeFromSuperview()

        datepicker.datePickerMode = .date
        datepicker.maximumDate = Date()
        datepicker.autoresizingMask = .flexibleWidth
        let pickerHeight:CGFloat = 250.0
        datepicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - pickerHeight, width: UIScreen.main.bounds.size.width, height: pickerHeight)
        toolBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - datepicker.height(), width: UIScreen.main.bounds.size.width, height: 50)
        self.view.addSubview(datepicker)
        self.view.addSubview(toolBar)
    }
    
    struct RescheduleWeeks {
        var startDate:Date?
        var endDate:Date?
    }
    
    func actionWeek() {
        rescheduleFlowType = .week
        datepicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        var endate = Date()
        
        for _ in 0..<12 {
            let startDate = endate.addDays(-6)
            let week = RescheduleWeeks(startDate: startDate, endDate: endate)
            repeatScheduleDataSource.append(week)
            endate = startDate.addDays(-1)
        }
        
        let pickerHeight:CGFloat = 250.0
        picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - pickerHeight, width: UIScreen.main.bounds.size.width, height: pickerHeight)
        toolBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - picker.height(), width: UIScreen.main.bounds.size.width, height: 50)
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
        picker.tag = PickerTag.RepeatSchedule.rawValue
        picker.reloadAllComponents()
        self.pickerView(self.picker, didSelectRow: 0, inComponent: 0)

    }
    
    
}

//MARK:- Keyboard delegate methods
extension AddNewScheduleViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            let newContentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            self.tableview.contentInset = newContentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let newContentInsets = UIEdgeInsets.zero
        self.tableview.contentInset = newContentInsets
    }
}
