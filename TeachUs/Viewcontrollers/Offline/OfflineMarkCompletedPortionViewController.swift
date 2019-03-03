//
//  OfflineMarkCompletedPortionViewController.swift
//  TeachUs
//
//  Created by ios on 7/22/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData

class OfflineMarkCompletedPortionViewController:BaseViewController {
    
    @IBOutlet weak var tableviewTopics: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
//    @IBOutlet weak var labelSyllabusCompletion: UILabel!
    var selectedCollege:Offline_Class_list!
    var attendanceParameters = [String:Any]()
    var attendanceId:NSNumber!
    var arrayDataSource:[Offline_Unit_syllabus_array] = []
    var updatedTopicList:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewTopics.register(UINib(nibName: "TopicDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId)
        self.title = "Syllabus Update"
        navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        self.getTopics()
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
        self.tableviewTopics.alpha = 1.0
    }
    
    @objc func viewDidBecomeActive(){
        #if DEBUG
            print("viewDidBecomeActive")
        #endif
        ReachabilityManager.shared.pauseMonitoring()
    }
    
    func getTopics(){
        /*
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getSyllabusSuubjectDetails
        var parameters = [String:Any]()
        parameters["subject_id"] = "\(selectedCollege.subject_id!)"
        parameters["class_id"] = "\(selectedCollege.class_id!)"
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        
        manager.apiPost(apiName: "Get topics for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let subjects = response["unit_syllabus_array"] as? [[String:Any]] else{
                return
            }
            
            if let completionPercent = response["syllabus_percentage"]
            {
//                self.labelSyllabusCompletion.text = "Completion: \(completionPercent)%"
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
        
        */
        
        self.makeTableView()
        self.tableviewTopics.reloadData()
        self.showTableView()

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
        UserManager.sharedUserManager.offlineAppuserCollegeDetails.class_list?.filter({ $0.class_id == self.selectedCollege.class_id}).first?.unit_syllabus_array! = self.arrayDataSource
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

extension OfflineMarkCompletedPortionViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopicDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId, for: indexPath) as! TopicDetailsTableViewCell
        
        let chapterCell:Offline_Topic_list = self.arrayDataSource[indexPath.section].topic_list![indexPath.row]
        cell.labelChapterNumber.text = chapterCell.topic_id!
        cell.labelChapterName.text = chapterCell.topic_name!
        cell.labelStatus.text = chapterCell.setChapterStatus
        //        cell.buttonSetStatus.roundedBlueButton()
        cell.buttonInProgress.indexPath = indexPath
        cell.buttonCompleted.indexPath = indexPath
        cell.buttonInProgress.addTarget(self, action:#selector( OfflineMarkCompletedPortionViewController.markChapterInProgress(_:)), for: .touchUpInside)
        cell.buttonCompleted.addTarget(self, action:#selector( OfflineMarkCompletedPortionViewController.markChapterInCompleted(_:)), for: .touchUpInside)
        
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
        return (self.arrayDataSource[section].topic_list?.count)!
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return self.arrayDataSource[section].unitName
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewTopics.width(), height: 44))
        headerView.backgroundColor = Constants.colors.themeLightBlue

        let labelView:UILabel  = UILabel(frame: CGRect(x: 15, y: 0, width: self.tableviewTopics.width(), height: 44))
        labelView.center.y = headerView.centerY()
        labelView.text = self.arrayDataSource[section].unit_name
        labelView.textColor = UIColor.rgbColor(51, 51, 51)
        headerView.addSubview(labelView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    @objc func markChapterInProgress(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        if(self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].status != "1"){
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].setChapterStatus = "In Progress"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].status = "1"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].chapterStatusTheme = .InProgress
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].topic_id!)",
                "status":"1" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].setChapterStatus = "Not Started"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].chapterStatusTheme = .NotStarted
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].status = "0"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].topic_id!)",
                "status":"1" ]
            self.updateUnitListArray(list: topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }
        
    }
    
    @objc func markChapterInCompleted(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        
        if(self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].status != "2"){
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].setChapterStatus = "Completed"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].chapterStatusTheme = .Completed
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].status = "2"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].topic_id!)",
                "status":"2" ] //status 2 is for completed topic / 1 is for inprogress
            self.updateUnitListArray(list: topicList)
            self.updatedTopicList.append(topicList)
            self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
        }else{//Not Started
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].setChapterStatus = "Not Started"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].chapterStatusTheme = .NotStarted
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].status = "0"
            self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].isUpdated = true
            let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topic_list![(indexpath.row)].topic_id!)",
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
