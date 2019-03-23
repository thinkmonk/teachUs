//
//  StudentAttendanceDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 3/21/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class StudentAttendanceDetailsViewController: BaseViewController {
    var selectedStudentAttendance:SubjectAttendance!
    var studentAttendanceDetails:AttendanceDetails!
    var arrayDataSource = [StudentAttendanceDetailsDataSource]()

    @IBOutlet weak var tableviewAttendanceDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.getAttendanceDetails()
        self.tableviewAttendanceDetails.register(UINib(nibName: "AttendanceDetailsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.studentAttendanceDetailsHeader)
        self.tableviewAttendanceDetails.register(UINib(nibName: "AttendanceDetailsValuesTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.studentAttendanceDetails)
        self.tableviewAttendanceDetails.estimatedRowHeight = 40
        self.tableviewAttendanceDetails.rowHeight = UITableViewAutomaticDimension
        self.tableviewAttendanceDetails.delegate = self
        self.tableviewAttendanceDetails.dataSource = self
        self.tableviewAttendanceDetails.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    
    func getAttendanceDetails(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.getAttendanceDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "subject_id":"\(selectedStudentAttendance.subjectId ?? "")",
        ]
        
        manager.apiPostWithDataResponse(apiName: " Get user Attendance details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                do{
                    let decoder = JSONDecoder()
                    self.studentAttendanceDetails = try decoder.decode(AttendanceDetails.self, from: response)
                    self.makeDataSource()
                }
                catch let error{
                    print("err", error)
                }
            }
            else{
                print("Error in fetching data")
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }

    }
    
    func makeDataSource()
    {
        self.arrayDataSource.removeAll()
        
        let headerDs = StudentAttendanceDetailsDataSource(detailsCell: .DetailsHeader, detailsObject: self.selectedStudentAttendance)
        self.arrayDataSource.append(headerDs)
        
        let titleDs = StudentAttendanceDetailsDataSource(detailsCell: .AttendanceTitle, detailsObject: nil)
        self.arrayDataSource.append(titleDs)
        
        
        for data in self.studentAttendanceDetails!.attendanceData!{
            let attendanceDs = StudentAttendanceDetailsDataSource(detailsCell:.AttendanceDetails , detailsObject: data)
            self.arrayDataSource.append(attendanceDs)
        }
        
        let footerDs = StudentAttendanceDetailsDataSource(detailsCell: .AttendanceFooter, detailsObject: nil)
        self.arrayDataSource.append(footerDs)
        
        self.tableviewAttendanceDetails.reloadData()
        self.showTableView()
    }
    
    func showTableView(){
        self.tableviewAttendanceDetails.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableviewAttendanceDetails.alpha = 1.0
            self.tableviewAttendanceDetails.transform = CGAffineTransform.identity
        }

    }

}

extension StudentAttendanceDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = self.arrayDataSource[indexPath.section] 
        
        switch dataSource.cellType! {
        case .DetailsHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.studentAttendanceDetailsHeader, for: indexPath) as! AttendanceDetailsHeaderTableViewCell
            cell.labelSubjectName.text = self.selectedStudentAttendance.subjectName
            cell.labelAttendanceCount.text = "\(self.selectedStudentAttendance.presentCount ?? "NA")/ \(self.selectedStudentAttendance.totalCount ?? "NA")"
            cell.labelAttendancePercentage.text = "\(self.selectedStudentAttendance.percentage ?? "NA")%"
            cell.backgroundColor = UIColor.rgbColor(5, 41, 107)
            cell.makeTopEdgesRounded()
            return cell
            
        case .AttendanceTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.studentAttendanceDetails, for: indexPath) as! AttendanceDetailsValuesTableViewCell
            cell.viewSeperatorBottom.isHidden = false
            return cell
            
        case .AttendanceDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.studentAttendanceDetails, for: indexPath) as! AttendanceDetailsValuesTableViewCell
            let attendanceData = dataSource.attachedObject as! AttendanceData
            cell.viewSeperatorBottom.isHidden = true
            cell.labelDate.text = attendanceData.date
            cell.labelLecturesTaken.text  = attendanceData.lecturesTaken
            cell.labelLecturesAtteended.text = attendanceData.lecturesAttended
            return cell
            
        case .AttendanceFooter:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.studentAttendanceDetails, for: indexPath) as! AttendanceDetailsValuesTableViewCell
            cell.labelDate.text = "Total"
            cell.labelLecturesAtteended.text = self.studentAttendanceDetails.totalLectureAttended
            cell.labelLecturesTaken.text = self.studentAttendanceDetails.totalLecturesTaken
            cell.viewcellBg.backgroundColor = UIColor.rgbColor(235, 235, 235)
            cell.viewSeperatorBottom.isHidden = true

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableviewAttendanceDetails.width(), height: 10.0))
        headerView.backgroundColor = section == 0 ? UIColor.clear : UIColor.white //make the first header transperent
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == (self.arrayDataSource.count-1){
            let footerView:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableviewAttendanceDetails.width(), height: 15.0))
            footerView.backgroundColor = UIColor.white
            footerView.makeBottomEdgesRounded()
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (self.arrayDataSource.count-1){
            return 15
        }
        return 0
    }
    
    
    
}
