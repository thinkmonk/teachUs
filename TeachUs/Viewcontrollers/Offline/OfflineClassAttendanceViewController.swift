//
//  OfflineClassAttendanceViewController.swift
//  TeachUs
//
//  Created by ios on 7/15/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OfflineClassAttendanceViewController: BaseViewController {

    var parentNavigationController : UINavigationController?
    var arrayCollegeList:[Offline_Class_list]? = []
    
    @IBOutlet weak var tableviewCollegeList: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewCollegeList.delegate = self
        tableviewCollegeList.dataSource = self
        self.tableviewCollegeList.alpha = 0
        self.getCollegeSummaryForProfessor()
        self.tableviewCollegeList.addSubview(refreshControl)
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewCollegeList.estimatedRowHeight = 44
        self.tableviewCollegeList.rowHeight = UITableViewAutomaticDimension
        self.tableviewCollegeList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ReachabilityManager.shared.resumeMomitoring()

    }
    
    override func refresh(sender: AnyObject) {
        self.getCollegeSummaryForProfessor()
        super.refresh(sender: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCollegeSummaryForProfessor(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.arrayCollegeList?.removeAll()
        for offlineClass in UserManager.sharedUserManager.offlineAppuserCollegeDetails.class_list!{
            self.arrayCollegeList?.append(offlineClass)
        }
        self.arrayCollegeList?.sort(by: { ($0.year!,$0.class_division! ,$0.subject_name!) < ($1.year!,$0.class_division!,$1.subject_name!) })

        UIView.animate(withDuration: 1.0, animations: {
            self.tableviewCollegeList.alpha = 1
        })
        self.tableviewCollegeList.reloadData()
        LoadingActivityHUD.hideProgressHUD()
    }
    
    
    func selectedSubject(_ subject: Offline_Class_list) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:OfflineStudentListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.OfflineStudentsListViewControllerId) as! OfflineStudentListViewController
        destinationVC.selectedCollege = subject
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension OfflineClassAttendanceViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayCollegeList!.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(cell == nil){
            let collegeCell:ProfessorCollegeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorCollegeList, for: indexPath) as! ProfessorCollegeListTableViewCell
            
            collegeCell.labelSubjectName.text = "\(self.arrayCollegeList![indexPath.section].year_name!)\(self.arrayCollegeList![indexPath.section].course_code!) - \(self.arrayCollegeList![indexPath.section].subject_name!) - \(self.arrayCollegeList![indexPath.section].class_division!)"
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            collegeCell.accessoryType = .disclosureIndicator
            cell = collegeCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewCollegeList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewCollegeList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSubject(self.arrayCollegeList![indexPath.section])
    }
}

extension OfflineClassAttendanceViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance")
    }

}
