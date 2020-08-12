//
//  MarkCompletedPortionViewController.swift
//  TeachUs
//
//  Created by ios on 11/17/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import CoreData
import RxSwift

enum SyllabusCompletetionType {
    case NotStarted
    case Completed
    case InProgress
}


class MarkCompletedPortionViewController: BaseViewController {
    
    @IBOutlet weak var tableviewTopics: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var labelSyllabusCompletion: UILabel!
    var selectedCollege:College!
    var attendanceParameters:[String:Any] = [:]
    var attendanceId:NSNumber!
    var updatedTopicList:[[String:Any]] = [] {
        didSet{
            self.buttonSubmit.isHidden = !(self.updatedTopicList.count > 0)
        }
    }
    
    var arrayDataSource = [MarkSyllabusDataSource]()
    var syllabusData:SyllabusStatusData!
    var attendanceDate:String = ""
    var lectureDetails:EditAttendanceLectureInfo! //for edit attendance,syllabusaflow
    var isEditAttendanceFlow:Bool = false
    var customTopicString = Variable<String>("")
    var doneToolbarButton:UIToolbar!
    private var myDisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attendanceDate = self.attendanceParameters["lecture_date"] as? String ?? ""
        self.tableviewTopics.register(UINib(nibName: "TopicDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId)
        self.tableviewTopics.register(UINib(nibName: "CustomSyllabusTopicTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.CustomSyllabusTopicTableViewCellId)
        self.title = "Syllabus Update"
        self.tableviewTopics.estimatedRowHeight = 110
        self.tableviewTopics.rowHeight = UITableViewAutomaticDimension
        self.tableviewTopics.alpha = 0.0
        self.isEditAttendanceFlow ? self.getEditSyllabusStatus() : self.getSyllabusStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(MarkCompletedPortionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MarkCompletedPortionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        initToolbar()
        setUpRx()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: .white)
        self.buttonSubmit.themeRedButton()
        self.buttonSubmit.isHidden = !(self.updatedTopicList.count > 0)
    }
    
    func setUpRx(){
        self.customTopicString.asObservable().subscribe(onNext: { (newValue) in
            self.buttonSubmit.isHidden = newValue.count == 0
        }).disposed(by: myDisposeBag)
    }
    
    func getEditSyllabusStatus()
    {
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getEditSyllabusAttendanceStatus
        var parameters = [String:Any]()
        parameters["subject_id"]    = self.lectureDetails.subjectId
        parameters["class_id"]      = self.lectureDetails.classId
        parameters["college_code"]  = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        parameters["lecture_date"]  = self.lectureDetails.lectureDate
        parameters["to_time"]       = self.lectureDetails.toTime
        parameters["from_time"]     = self.lectureDetails.fromTime
        parameters["att_id"] = self.attendanceId
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        manager.apiPostWithDataResponse(apiName: "Get syllabus status for attendance marking", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.syllabusData = try decoder.decode(SyllabusStatusData.self, from: response)
                self.makeDataSource()
            }
            catch let error{
                self.showErrorAlert(.ParsingError) { (retry) in
                    if (retry){
                        self.getSyllabusStatus()
                    }
                }
                print("err", error)
            }
            
            
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            self.showErrorAlert(.ServerCallFailed) { (retry) in
                if (retry){
                    self.getSyllabusStatus()
                }
            }
            print(message)
            
        }
    }
    
    
    func getSyllabusStatus(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getSyllabusAttendanceStatus
        var parameters = [String:Any]()
        parameters["subject_id"]    = "\(selectedCollege.subjectId!)"
        parameters["class_id"]      = "\(selectedCollege.classId!)"
        parameters["college_code"]  = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        if let lectureDate = attendanceParameters["lecture_date"] as? String,
            let fromTIme = attendanceParameters["from_time"] as? String,
            let toTIme = attendanceParameters["to_time"] as? String
        {
            parameters["lecture_date"]  = lectureDate
            parameters["to_time"]       = fromTIme
            parameters["from_time"]     = toTIme
        }
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiPostWithDataResponse(apiName: "Get syllabus status for attendance marking", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.syllabusData = try decoder.decode(SyllabusStatusData.self, from: response)
                self.makeDataSource()
            }
            catch let error{
                self.showErrorAlert(.ParsingError) { (retry) in
                    if (retry){
                        self.getSyllabusStatus()
                    }
                }
                print("err", error)
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            self.showErrorAlert(.ServerCallFailed) { (retry) in
                if (retry){
                    self.getSyllabusStatus()
                }
            }
            print(message)
            
        }
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        if self.syllabusData.unitSyllabusArray.count > 0{
            for unitObj in self.syllabusData.unitSyllabusArray{
                let dsObj = MarkSyllabusDataSource(cellType: .Unit, attachedObject: unitObj)
                arrayDataSource.append(dsObj)
            }
            
            let otherUniObj = MarkSyllabusDataSource(cellType: .Other, attachedObject: nil)
            arrayDataSource.append(otherUniObj)
        }
        
        DispatchQueue.main.async {
            self.labelSyllabusCompletion.text = "Completion: \(self.syllabusData.syllabusPercentage)%"
            self.makeTableView()
            self.tableviewTopics.reloadData()
            self.showTableView()
        }
    }
    
    func makeTableView(){
        self.tableviewTopics.delegate = self
        self.tableviewTopics.dataSource = self
    }
    func showTableView(){
        self.tableviewTopics.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableviewTopics.alpha = 1.0
            self.tableviewTopics.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func submitSyllabusStatus(_ sender: Any) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.buttonSubmit.isEnabled = false
        print(ReachabilityManager.shared.reachabilityStatus.description)
        if(ReachabilityManager.shared.reachability.connection != .none){
            submitAttendanceAndSyllabus()
        }
        else{
            saveAttendanceAndSyllabusToDb()
        }
        
    }
    
    func submitAttendanceAndSyllabus(){
        let manager = NetworkHandler()
        if self.isEditAttendanceFlow{
            manager.url = URLConstants.ProfessorURL.submitEditedAttendace
        }else{
            manager.url = URLConstants.ProfessorURL.mergedAttendanceAndSyllabus
        }
        let topicList = ["topic_list":self.updatedTopicList]
        var requestString  =  ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: topicList,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        self.attendanceParameters["topic_list"] = requestString
        self.attendanceParameters["otherstopic"] = self.customTopicString.value
        
        manager.apiPost(apiName: "mark syllabus professor", parameters: self.attendanceParameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let status = response["status"] as? NSNumber else{
                return
            }
            if (status == 200){
                Vibration.success.vibrate()
                self.attendanceId = response["att_id"] as? NSNumber
                let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    if self.isEditAttendanceFlow{
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: LogsDetailViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }

                    }else{
                        self.performSegue(withIdentifier: Constants.segues.toLectureReport, sender: self)
                    }
                }))
                self.present(alert, animated: true, completion:nil)
                self.buttonSubmit.isEnabled = true
            }
        }) { [weak self] (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            self?.showAlertWithTitle("Error", alertMessage: message)
            self?.buttonSubmit.isEnabled = true
        }
    }
    
    func saveAttendanceAndSyllabusToDb(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.submitSyllabusCovered
        var parameters = [String:Any]()
        
        //        parameters["college_code"] = "\(UserManager.sharedUserManager.offlineAppuserCollegeDetails.college_code!)"
        //        parameters["att_id"] = self.attendanceId!
        let topicList = ["topic_list":self.updatedTopicList]
        var requestString  =  ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: topicList,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        parameters["topic_list"] = requestString
        parameters["otherstopic"] = self.customTopicString.value
        
        let api:OfflineApiRequest = NSEntityDescription.insertNewObject(forEntityName: "OfflineApiRequest", into: DatabaseManager.managedContext) as! OfflineApiRequest
        api.attendanceParams = self.attendanceParameters as NSObject
        api.syllabusParams = parameters as NSObject
        DatabaseManager.saveDbContext()
        UserManager.sharedUserManager.updateOfflineUserData()
        let alert = UIAlertController(title: nil, message: "Syllabus Recorded", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: OfflineHomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toLectureReport{
            let destinationVc:LectureReportViewController = segue.destination as! LectureReportViewController
            destinationVc.selectedAttendanceId = self.attendanceId
        }
    }
}

extension MarkCompletedPortionViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[indexPath.section]
        switch dataSourceObj.syallbusCellType {
        case .Unit:
            let cell:TopicDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId, for: indexPath) as! TopicDetailsTableViewCell
            
            guard let unitObj = dataSourceObj.attachedObject as? UnitSyllabusArray else{
                return cell
            }
            let chapterCell = unitObj.topicList[indexPath.row]
            cell.labelChapterName.text = chapterCell.topicName
            cell.labelStatus.text = chapterCell.setChapterStatus
            //        cell.buttonSetStatus.roundedBlueButton()
            cell.buttonInProgress.indexPath = indexPath
            cell.buttonCompleted.indexPath = indexPath
            cell.buttonInProgress.addTarget(self, action:#selector( MarkCompletedPortionViewController.markChapterInProgress(_:)), for: .touchUpInside)
            cell.buttonCompleted.addTarget(self, action:#selector( MarkCompletedPortionViewController.markChapterInCompleted(_:)), for: .touchUpInside)
            switch chapterCell.chapterStatusTheme! {
            case .Completed:
                cell.buttonCompleted.selectedGreenButton()
                cell.buttonInProgress.selectedDefaultButton()
                cell.labelStatus.textColor = UIColor.rgbColor(0.0, 143.0, 83.0) //#008F53
                cell.viewDisableCell.alpha = chapterCell.isUpdated ? 0 : 1 //show disabled view by default.
                //            cell.viewStatusStack.alpha = 0
                //            cell.viewwSeperator.alpha = 0
                break
            case .InProgress:
                cell.buttonInProgress.selectedRedButton()
                cell.buttonCompleted.selectedDefaultButton()
                cell.labelStatus.textColor = UIColor.rgbColor(299.0, 0.0, 0.0)   //#E50000
                cell.viewDisableCell.alpha = 0
                let topicList = ["topic_id":"\(chapterCell.topicId)",
                    "status":"1" ]
                self.updateUnitListArray(list: topicList)
                self.updatedTopicList.append(topicList)
                
                //            cell.viewStatusStack.alpha = 1
                //            cell.viewwSeperator.alpha = 1
                
                break
            case .NotStarted:
                cell.buttonCompleted.selectedDefaultButton()
                cell.buttonInProgress.selectedDefaultButton()
                cell.labelStatus.textColor = UIColor.rgbColor(126.0, 132.0, 155.0) //#7E849B
                cell.viewDisableCell.alpha = 0
                //            cell.viewStatusStack.alpha = 1
                //            cell.viewwSeperator.alpha = 1
                
                break
            }
            cell.selectionStyle = .none
            return cell
            
        case .Other:
            let cell:CustomSyllabusTopicTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.CustomSyllabusTopicTableViewCellId, for: indexPath) as! CustomSyllabusTopicTableViewCell
            cell.textFieldTopicInput.rx.text.map{ $0 ?? ""}.bind(to: self.customTopicString).disposed(by: cell.myCellDisposeBag)
            cell.selectionStyle = .none
            cell.textFieldTopicInput.inputAccessoryView = doneToolbarButton
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[section]
        switch dataSourceObj.syallbusCellType {
        case .Unit:
            return dataSourceObj.rowCount
        case .Other: return 1
        case .none: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[section]
        switch dataSourceObj.syallbusCellType {
        case.Unit:
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewTopics.width(), height: 44))
            headerView.backgroundColor = Constants.colors.themeLightBlue
            let labelView:UILabel  = UILabel(frame: CGRect(x: 15, y: 0, width: self.tableviewTopics.width(), height: 44))
            labelView.center.y = headerView.centerY()
            guard let unitObj = dataSourceObj.attachedObject as? UnitSyllabusArray else{
                return nil
            }
            labelView.text = unitObj.unitName
            labelView.textColor = UIColor.rgbColor(51, 51, 51)
            headerView.addSubview(labelView)
            return headerView
            
            
        default:return nil
        }
        
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
 */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dataSourceObj:MarkSyllabusDataSource = arrayDataSource[section]
        switch dataSourceObj.syallbusCellType {
        case.Unit: return 44
        default : return 0
        }
    }
    
    @objc func markChapterInProgress(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        let chapterObj = self.syllabusData.unitSyllabusArray[(indexpath.section)].topicList[(indexpath.row)]
        if(chapterObj.status != "1"){
            chapterObj.setChapterStatus = "In Progress"
            chapterObj.status = "1"
            chapterObj.chapterStatusTheme = .InProgress
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topicId)",
                "status":"1" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            chapterObj.setChapterStatus = "Not Started"
            chapterObj.chapterStatusTheme = .NotStarted
            chapterObj.status = "0"
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topicId)",
                "status":"1" ]
            self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
        
    }

    @objc func markChapterInCompleted(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        var chapterObj = self.syllabusData.unitSyllabusArray[(indexpath.section)].topicList[(indexpath.row)]
        
        
        if chapterObj.resultStatusFlag == "2"{ //chapter has been mark completed in future hence cannot mark it completed in present.
            self.showAlertWithTitle("Chapter Completed", alertMessage: "Topic marked completed on \(chapterObj.resultStatusDate ?? "")")
            return
        }else if let futureDate = chapterObj.resultStatusDate?.convertToDate(),
            let attendanceDate = self.attendanceDate.convertToDate(),
            (chapterObj.resultStatusFlag == "1" && (futureDate > attendanceDate))
        { //chapter is in progress in the future date as well, hence cannot be mark complted in past
            self.showAlertWithTitle("Chapter In-Progress", alertMessage: "Topic marked In-Progess on \(futureDate)")
            return
        }
        
        
        if(chapterObj.status != "2"){
            chapterObj.setChapterStatus = "Completed"
            chapterObj.chapterStatusTheme = .Completed
            chapterObj.status = "2"
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topicId)",
                "status":"2" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            chapterObj.setChapterStatus = "Not Started"
            chapterObj.chapterStatusTheme = .NotStarted
            chapterObj.status = "0"
            chapterObj.isUpdated = true
            let topicList = ["topic_id":"\(chapterObj.topicId)",
                    "status":"1" ]
                self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
    }
    
    func updateUnitListArray(list:[String:String]){//maintain a single instance of all the updated units.
        for i in 0..<updatedTopicList.count{
            let topic = updatedTopicList[i]
            let tempCurrentTopic = topic["topic_id"] as! String
            let tempOuterTopic = list["topic_id"]
            if(tempCurrentTopic == tempOuterTopic){
                updatedTopicList.remove(at: i)
                return
            }
        }
    }

}


//MARK:- Keyboard delegate methods
extension MarkCompletedPortionViewController{
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            let newContentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            self.tableviewTopics.contentInset = newContentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let newContentInsets = UIEdgeInsets.zero
        self.tableviewTopics.contentInset = newContentInsets
    }
    
    func initToolbar(){
        doneToolbarButton = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width(), height: 50))
        doneToolbarButton.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MarkCompletedPortionViewController.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbarButton.items = items
        doneToolbarButton.sizeToFit()

    }
    

    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

}
