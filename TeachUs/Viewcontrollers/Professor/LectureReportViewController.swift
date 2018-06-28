//
//  LectureReportViewController.swift
//  TeachUs
//
//  Created by ios on 5/11/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
class LectureReportViewController: BaseViewController {

    @IBOutlet weak var tableLectureReport: UITableView!
    @IBOutlet weak var buttonGoToDashboard: UIButton!
    var lectureReportModel:LectureReport!
    var arrayDataSource:[LectureReportDataSource] = []
    var selectedAttendanceId:NSNumber!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.title = "Lecture Report"
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LectureReportViewController.goToHome))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.buttonGoToDashboard.addTarget(self, action: #selector(LectureReportViewController.goToHome), for: .touchUpInside)
        self.getLectureReport()
        self.tableLectureReport.alpha = 0
        self.tableLectureReport.estimatedRowHeight = 70
        self.tableLectureReport.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonGoToDashboard.roundedBlueButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableLectureReport.makeTableCellEdgesRounded()
    }
    
    @objc func goToHome(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func getLectureReport(){
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getLectureReport
        var parameters = [String:Any]()
        parameters["att_id"] = self.selectedAttendanceId.intValue
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        
        
        manager.apiPost(apiName: "Get Lecture report for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let subjects = response["lecture_report"] as? [String:Any] else{
                return
            }
            self.lectureReportModel = Mapper<LectureReport>().map(JSON: subjects)
            self.makeDataSource()
            
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    func makeDataSource(){
        self.arrayDataSource.removeAll()
        
        let classDataSource = LectureReportDataSource(cellType: .ClassName, object: nil)
        self.arrayDataSource.append(classDataSource)
        
        let timeDataSource = LectureReportDataSource(cellType: .LectureTIme, object: nil)
        self.arrayDataSource.append(timeDataSource)

        let numOfLectureDataSource = LectureReportDataSource(cellType: .NumberOfLecture, object: nil)
        self.arrayDataSource.append(numOfLectureDataSource)

        let totalAttendanceDataSource = LectureReportDataSource(cellType: .TotalAttendance, object: nil)
        self.arrayDataSource.append(totalAttendanceDataSource)

        let submissionTImeDataSource = LectureReportDataSource(cellType: .TimeOfSubmission, object: nil)
        self.arrayDataSource.append(submissionTImeDataSource)

        let subjectDataSource = LectureReportDataSource(cellType: .SubjectDetails, object: nil)
        self.arrayDataSource.append(subjectDataSource)
        
        self.makeTableView()
        self.tableLectureReport.reloadData()
        self.showTableView()

    }
    
    func makeTableView(){
        self.tableLectureReport.delegate = self
        self.tableLectureReport.dataSource = self
    }
    func showTableView(){
        self.tableLectureReport.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableLectureReport.alpha = 1.0
            self.tableLectureReport.transform = CGAffineTransform.identity
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LectureReportViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellDataSource = arrayDataSource[indexPath.row]
        switch cellDataSource.reportCellType! {
        case .ClassName:
            let cell:LectureReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LectureReportCellId, for: indexPath) as! LectureReportTableViewCell

            cell.imageViewReportIcon.image = UIImage(named: "lectureIcon")
            cell.labelReportTitle.text = "Class :"
            cell.labelReportDescription.text = lectureReportModel.courseName
            return cell

            
        case .LectureTIme:
            let cell:LectureReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LectureReportCellId, for: indexPath) as! LectureReportTableViewCell

            cell.imageViewReportIcon.image = UIImage(named: "clockIcon")
            cell.labelReportTitle.text = "Time :"
            cell.labelReportDescription.text = "\(lectureReportModel.fromTime) to \(lectureReportModel.toTime)"
            return cell

        case .NumberOfLecture:
            let cell:LectureReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LectureReportCellId, for: indexPath) as! LectureReportTableViewCell

            cell.imageViewReportIcon.image = UIImage(named: "lectureIcon")
            cell.labelReportTitle.text = "Lectures taken :"
            cell.labelReportDescription.text = lectureReportModel.numberOfLecture
            return cell

        case .TotalAttendance:
            let cell:LectureReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LectureReportCellId, for: indexPath) as! LectureReportTableViewCell

            cell.imageViewReportIcon.image = UIImage(named: "lectureIcon")
            cell.labelReportTitle.text = "Total Attendance :"
            cell.labelReportDescription.text = lectureReportModel.totalAttendanceCount
            return cell

        case .TimeOfSubmission:
            let cell:LectureReportTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LectureReportCellId, for: indexPath) as! LectureReportTableViewCell

            cell.imageViewReportIcon.image = UIImage(named: "clockIcon")
            cell.labelReportTitle.text = "Time of Submission :"
            cell.labelReportDescription.text = lectureReportModel.modifiedOn
            return cell

        case .SubjectDetails:
            let cell:LectureReportSubjectTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.LectureReportTopicsCoveredCellId, for: indexPath) as! LectureReportSubjectTableViewCell
            cell.imageViewReportIcon.image = UIImage(named: "subjectIcon")
            cell.labelReportTitle.text = "Subject :"
            cell.labelReportDescription.text = lectureReportModel.subjectName
            var stringTopicCovered = ""
            for unit in lectureReportModel.unitDetails{
                stringTopicCovered = stringTopicCovered + unit.unitName + ":"
                for topic in unit.topicArray!{
                    stringTopicCovered = stringTopicCovered + topic.chapterName + "\n"
                }
            }
            cell.labelSubjectTitle.text = "Topics Covered :"
            cell.labelSubjectDescription.text = stringTopicCovered
            return cell
        }
    }
    
    
}
