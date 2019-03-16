//
//  CollegeLogsProfessorListViewController.swift
//  TeachUs
//
//  Created by ios on 3/16/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class CollegeLogsProfessorListViewController: BaseViewController
{
    
    @IBOutlet weak var tableViewProfessorName: UITableView!
    var errorLabel : UILabel!
    var parentNavigationController : UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewProfessorName.register(UINib(nibName: "TeacherDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId)

        self.tableViewProfessorName.delegate = self
        self.tableViewProfessorName.dataSource = self
        self.tableViewProfessorName.estimatedRowHeight = 40
        self.tableViewProfessorName.rowHeight = UITableViewAutomaticDimension
        self.tableViewProfessorName.alpha = 0.0
        self.tableViewProfessorName.addSubview(refreshControl)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpLogs()
    }
    
    override func refresh(sender: AnyObject) {
        self.setUpLogs()
        super.refresh(sender: sender)
    }
    
    func showTableView(){
        self.tableViewProfessorName.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewProfessorName.alpha = 1.0
            self.tableViewProfessorName.transform = CGAffineTransform.identity
        }
    }
    
    func setUpLogs(){
        ProfessorLogsManager.sharedManager.getAllProfessorlist { (isExists) in
            if(isExists){
                if self.errorLabel != nil{
                    self.errorLabel.removeFromSuperview()
                }
                DispatchQueue.main.async {
                    self.tableViewProfessorName.reloadData()
                    self.showTableView()
                }
            }else{
                self.errorLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.width() * 0.80, height: 20))
                self.errorLabel.center = self.view.center
                self.errorLabel.text = "Unable to fetch professor list"
                self.errorLabel.numberOfLines = 0
                self.view.addSubview(self.errorLabel)
            }
        }
    }
    
}


extension CollegeLogsProfessorListViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let professsorList = ProfessorLogsManager.sharedManager.collegeProfessorList{
            return professsorList.professorSubjects.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TeacherDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId, for: indexPath) as! TeacherDetailsTableViewCell
        let details:ProfessorSubject = (ProfessorLogsManager.sharedManager.collegeProfessorList?.professorSubjects[indexPath.section])!
        cell.setUpProfessorLogCellDetails(tempDetails: details)
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewProfessorName.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details:ProfessorSubject = (ProfessorLogsManager.sharedManager.collegeProfessorList?.professorSubjects[indexPath.section])!

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let professorLogsListVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorLogs) as! ProfessorLogsListViewController
        professorLogsListVC.isCollegeLogsSubjectData = true
        professorLogsListVC.selectedProffessorId = details.professorID
        professorLogsListVC.navigationController?.navigationBar.alpha = 1
        self.navigationController?.pushViewController(professorLogsListVC, animated: true)

    }
}

extension CollegeLogsProfessorListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Logs")
    }
}
