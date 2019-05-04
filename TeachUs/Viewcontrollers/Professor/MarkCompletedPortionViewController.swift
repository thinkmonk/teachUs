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
    var arrayDataSource:[Unit] = []
    var updatedTopicList:[[String:Any]] = []
    var syllabusData:[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewTopics.register(UINib(nibName: "TopicDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId)
        self.title = "Syllabus Update"
        navigationItem.hidesBackButton = true
        self.tableviewTopics.estimatedRowHeight = 110
        self.tableviewTopics.rowHeight = UITableViewAutomaticDimension
        self.tableviewTopics.alpha = 0.0
        self.mapTopicsToDataSource()
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
    }
    
    func mapTopicsToDataSource(){
        guard let subjects = self.syllabusData["unit_syllabus_array"] as? [[String:Any]] else{
            return
        }
        
        if let completionPercent = self.syllabusData["syllabus_percentage"]
        {
            self.labelSyllabusCompletion.text = "Completion: \(completionPercent)%"
        }
        else{
            return
        }
        
        for subject in subjects{
            let tempSubject = Mapper<Unit>().map(JSON: subject)
            self.arrayDataSource.append(tempSubject!)
        }
        self.makeTableView()
        self.tableviewTopics.reloadData()
        self.showTableView()
    }
    
    func getTopics(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getSyllabusSuubjectDetails
        var parameters = [String:Any]()
        parameters["subject_id"] = "\(selectedCollege.subjectId!)"
        parameters["class_id"] = "\(selectedCollege.classId!)"
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)

        
        manager.apiPost(apiName: "Get topics for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let subjects = response["unit_syllabus_array"] as? [[String:Any]] else{
                return
            }
            
            if let completionPercent = response["syllabus_percentage"]
            {
                self.labelSyllabusCompletion.text = "Completion: \(completionPercent)%"
            }
            else{
                return
            }
            
            for subject in subjects{
                let tempSubject = Mapper<Unit>().map(JSON: subject)
                self.arrayDataSource.append(tempSubject!)
            }
            self.makeTableView()
            self.tableviewTopics.reloadData()
            self.showTableView()
            
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            
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
        manager.url = URLConstants.ProfessorURL.mergedAttendanceAndSyllabus
        let topicList = ["topic_list":self.updatedTopicList]
        var requestString  =  ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: topicList,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        self.attendanceParameters["topic_list"] = requestString
        
        manager.apiPost(apiName: "mark syllabus professor", parameters: self.attendanceParameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let status = response["status"] as? NSNumber else{
                return
            }
            if (status == 200){
                self.attendanceId = response["att_id"] as? NSNumber
                let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.performSegue(withIdentifier: Constants.segues.toLectureReport, sender: self)
                }))
                self.present(alert, animated: true, completion:nil)
                
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            
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
        let cell:TopicDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId, for: indexPath) as! TopicDetailsTableViewCell
        
        let chapterCell:Chapter = self.arrayDataSource[indexPath.section].topicArray![indexPath.row]
        cell.labelChapterNumber.text = chapterCell.chapterNumber
        cell.labelChapterName.text = chapterCell.chapterName
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
            cell.viewDisableCell.alpha = chapterCell.isUpdated ? 0 : 1
//            cell.viewStatusStack.alpha = 0
//            cell.viewwSeperator.alpha = 0
            break
        case .InProgress:
            cell.buttonInProgress.selectedRedButton()
            cell.buttonCompleted.selectedDefaultButton()
            cell.labelStatus.textColor = UIColor.rgbColor(299.0, 0.0, 0.0)   //#E50000
            cell.viewDisableCell.alpha = 0
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayDataSource[section].topicArray?.count)!
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.arrayDataSource[section].unitName
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewTopics.width(), height: 44))
        headerView.backgroundColor = Constants.colors.themeLightBlue
        let labelView:UILabel  = UILabel(frame: CGRect(x: 15, y: 0, width: self.tableviewTopics.width(), height: 44))
        labelView.center.y = headerView.centerY()
        labelView.text = self.arrayDataSource[section].unitName
        labelView.textColor = UIColor.rgbColor(51, 51, 51)
        headerView.addSubview(labelView)
        return headerView
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
 */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    @objc func markChapterInProgress(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        if(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].status != "1"){
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "In Progress"
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].status = "1"
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .InProgress
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterId)",
                "status":"1" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "Not Started"
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .NotStarted
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].status = "0"
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterId)",
                "status":"1" ]
            self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
        
    }

    @objc func markChapterInCompleted(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        
        if(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].status != "2"){
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "Completed"
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .Completed
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].status = "2"
              self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterId)",
                "status":"2" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
                self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "Not Started"
                self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .NotStarted
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].status = "0"
            self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].isUpdated = true
                let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterId)",
                    "status":"1" ]
                self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
    }
    
    func updateUnitListArray(list:[String:String]){
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
