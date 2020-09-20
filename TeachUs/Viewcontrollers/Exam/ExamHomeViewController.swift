//
//  ExamHomeViewController.swift
//  TeachUs
//
//  Created by iOS on 18/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ExamHomeViewController: BaseViewController {

    var parentNavigationController : UINavigationController?
    @IBOutlet weak var tableviewExamSchedule: UITableView!
    var scheduleObj:ExamSchedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewExamSchedule.register(UINib(nibName: "ExamScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.examSchedule)
        tableviewExamSchedule.estimatedRowHeight = 40
        tableviewExamSchedule.rowHeight = UITableViewAutomaticDimension
        tableviewExamSchedule.backgroundColor = .clear
        tableviewExamSchedule.dataSource = self
        tableviewExamSchedule.delegate = self
        tableviewExamSchedule.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getExamsList()
    }
    
    override func refresh(sender: AnyObject) {
        self.getExamsList()
        super.refresh(sender: sender)
    }
    
    func getExamsList()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Exam.getExamList
        
        let queryParams = URLQueryItem(name: "StudID", value: "\(UserManager.sharedUserManager.getStudentExamId())")
        manager.url?.addQueryParamsToUrl(queryParams: [queryParams])
        
        manager.apiGetWithDataResponse(apiName: "get all exam data", completionHandler: { [weak self] (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                do{
                    let decoder = JSONDecoder()
                    self?.scheduleObj = try decoder.decode(ExamSchedule.self, from: response)
                    if !(self?.scheduleObj?.data?.isEmpty ?? false) {
                        self?.tableviewExamSchedule.reloadData()
                    }
                }
                catch let error{
                    print("err", error)
                }
            }
            else{
                self?.showAlertWithTitle(nil, alertMessage: "Unable to fetch exam list")
            }
        }) {[weak self] (error, code, message) in
            self?.showAlertWithTitle(nil, alertMessage: "\(message)")
        }
    }


}

extension ExamHomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.scheduleObj?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExamScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.examSchedule, for: indexPath) as! ExamScheduleTableViewCell
        guard let examObj = self.scheduleObj?.data?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.setupCell(with: examObj)
        cell.accessoryType = examObj.takenTest?.boolValue() ?? false ? .none : .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewExamSchedule.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let exam = self.scheduleObj?.data?[indexPath.section], let examID = exam.paperId else {
            return
        }
        
        if shouldAllowToEnterExam(for: exam){
            let destinationVC:ExamWebViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.examWebView) as! ExamWebViewController
            var url =  URLConstants.Exam.examUrl
            
            let queryParams = [URLQueryItem(name: "d", value: "\(examID)"),
                               URLQueryItem(name: "student_id", value: UserManager.sharedUserManager.getStudentExamId())]
            url.addQueryParamsToUrl(queryParams: queryParams)
            destinationVC.urlString = url
            //        destinationVC.urlString = "https://exam.parshvaa.com/student-app/mcq-test-paper/start_test/?d=35911&student_id=39342"
            
            destinationVC.parentNavigationController = self.parentNavigationController
            self.parentNavigationController?.pushViewController(destinationVC, animated: true)
        } else {
            showAlertWithTitle("Exam not started", alertMessage: "Exam will start at \(exam.startTime ?? "") \n Entry will be permitted 15 minutes before the exam time")
        }
    }
    
    func shouldAllowToEnterExam(for exam:ScheduleData) -> Bool{
        guard let startTime = exam.startTime, let endDate = exam.expiryDate?.convertToDate() else {
            return true //allowing student to visit the exam section
        }
        
        //check for date difference
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        if components.day != 0 {
            return true //allowing student to visit the exam section
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeDate = dateFormatter.date(from: startTime)!

        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())
        let difference = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
        return difference > 15 // this willl allow the student to enter the exam only before 15 mins.
    }
}


extension ExamHomeViewController:IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Exam")
    }
}
