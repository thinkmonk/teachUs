//
//  CollegeAttendanceListViewController.swift
//  TeachUs
//
//  Created by ios on 3/18/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper

class CollegeAttendanceListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[CollegeAttendanceList]? = []
    @IBOutlet weak var tableViewCollegeAttendanceList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewCollegeAttendanceList.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        self.tableViewCollegeAttendanceList.delegate = self
        self.tableViewCollegeAttendanceList.dataSource = self
        self.tableViewCollegeAttendanceList.alpha = 0.0
        getClassAttendance()
        self.addDefaultBackGroundImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getClassAttendance(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classAttendanceList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: " Get class attendance", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let attendanceListArray = response["class_attendance_list"] as? [[String:Any]] else{
                return
            }
            for attendancelist in attendanceListArray{
                let tempList = Mapper<CollegeAttendanceList>().map(JSONObject: attendancelist)
                self.arrayDataSource?.append(tempList!)
            }
            self.tableViewCollegeAttendanceList.reloadData()
            self.showTableView()
            
            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    func showTableView(){
        self.tableViewCollegeAttendanceList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewCollegeAttendanceList.alpha = 1.0
            self.tableViewCollegeAttendanceList.transform = CGAffineTransform.identity
        }
    }

}

extension  CollegeAttendanceListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.arrayDataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewCollegeAttendanceList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //***have reused the syllabus-details cell***

        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath) as! SyllabusStatusTableViewCell
        cell.labelSubject.text = "\(self.arrayDataSource![indexPath.section].courseName)"
        cell.labelNumberOfLectures.text =  "\(self.arrayDataSource![indexPath.section].totalStudents)"
        cell.labelAttendancePercent.text = "\(self.arrayDataSource![indexPath.section].avgStudents)"
        cell.imageViewArrow.isHidden = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segues.toCollegeAttendanceDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toCollegeAttendanceDetail {
            let destinationVC:CollegeAttendanceDetailsViewController = segue.destination as! CollegeAttendanceDetailsViewController
            destinationVC.collegeClass = self.arrayDataSource![(self.tableViewCollegeAttendanceList.indexPathForSelectedRow?.row)!]
        }
    }
}

extension CollegeAttendanceListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance (Reports)")
    }
}
