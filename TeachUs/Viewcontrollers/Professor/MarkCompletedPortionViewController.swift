//
//  MarkCompletedPortionViewController.swift
//  TeachUs
//
//  Created by ios on 11/17/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

enum SyllabusCompletetionType {
    case NotStarted
    case Completed
    case InProgress
}


class MarkCompletedPortionViewController: BaseViewController {

    @IBOutlet weak var tableviewTopics: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var selectedCollege:College!
    var attendanceId:NSNumber!
    var arrayDataSource:[Unit] = []
    var updatedTopicList:[[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewTopics.register(UINib(nibName: "TopicDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TopicDetailsTableViewCellId)

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
        self.tableviewTopics.alpha = 0.0
    }
    
    func getTopics(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getSyllabusSuubjectDetails
        var parameters = [String:Any]()
        parameters["subject_id"] = "\(selectedCollege.subjectId!)"
        parameters["class_id"] = "\(selectedCollege.classId!)"
//        parameters["subject_id"] = "3"
//        parameters["class_id"] = "1"
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)

        
        manager.apiPost(apiName: "Get topics for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let subjects = response["unit_syllabus_array"] as? [[String:Any]] else{
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
        /*
        manager.url = URLConstants.ProfessorURL.topicList
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get topics for professor", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let topics = response["topicWise"] as? [[String:Any]] else{
                return
            }

            for topic in topics{
                let tempTopic = Mapper<Unit>().map(JSON: topic)
                self.arrayDataSource.append(tempTopic!)
            }
            self.makeTableView()
            self.tableviewTopics.reloadData()
            self.showTableView()
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
 */
         
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
        parameters["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        parameters["att_id"] = self.attendanceId!
        let topicList = ["topic_list":self.updatedTopicList]
        var requestString  =  ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: topicList,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        parameters["topic_list"] = requestString
        manager.apiPost(apiName: "mark syllabus professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let status = response["status"] as? NSNumber else{
                return
            }
            if (status == 200){
                
                let alert = UIAlertController(title: nil, message: response["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                self.performSegue(withIdentifier: Constants.segues.toLectureReport, sender: self)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    //                    for controller in self.navigationController!.viewControllers as Array {
                    //                        self.markedAttendanceId = response["att_id"]
                    //                        self.performSegue(withIdentifier: Constants.segues.markPortionCompleted, sender: self)
                    //                        if controller.isKind(of: HomeViewController.self) {
                    //                            self.navigationController!.popToViewController(controller, animated: true)
                    //                            break
                    //                        }
                    //                    }
                }))
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            
        }
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
            cell.labelStatus.textColor = UIColor.green
            break
        case .InProgress:
            cell.buttonInProgress.selectedRedButton()
            cell.buttonCompleted.selectedDefaultButton()
            cell.labelStatus.textColor = UIColor.red
            break
        case .NotStarted:
            cell.buttonCompleted.selectedDefaultButton()
            cell.buttonInProgress.selectedDefaultButton()
            cell.labelStatus.textColor = UIColor.yellow
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.arrayDataSource[section].unitName
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    @objc func markChapterInProgress(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "In Progress"
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .InProgress
        let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterId)",
            "status":"1" ] //status 2 is for completed topic / 1 is for inprogress
        self.updatedTopicList.append(topicList)
        self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)

        
    }
    @objc func markChapterInCompleted(_ sender: ButtonWithIndexPath){
        let indexpath = sender.indexPath!
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].setChapterStatus = "Completed"
        self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterStatusTheme = .Completed
        let topicList = ["topic_id":"\(self.arrayDataSource[(indexpath.section)].topicArray![(indexpath.row)].chapterId)",
            "status":"2" ] //status 2 is for completed topic / 1 is for inprogress
        self.updatedTopicList.append(topicList)
        self.tableviewTopics.reloadRows(at: [indexpath], with: .fade)
    }

}
