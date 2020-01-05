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
    @IBOutlet weak var buttonMailReport: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var errorLabel : UILabel!
    var parentNavigationController : UINavigationController?
    var viewMailReport:ViewProfessorMailReport!
    var searchText:String = ""
    var filteredProfessorList : CollegeProfessorList?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewProfessorName.register(UINib(nibName: "TeacherDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId)

        self.tableViewProfessorName.delegate = self
        self.tableViewProfessorName.dataSource = self
        self.tableViewProfessorName.estimatedRowHeight = 55
        self.tableViewProfessorName.rowHeight = UITableViewAutomaticDimension
        self.tableViewProfessorName.alpha = 0.0
        self.tableViewProfessorName.addSubview(refreshControl)
        self.buttonMailReport.themeRedButton()
        searchBar.delegate = self

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
                    self.filteredProfessorList = ProfessorLogsManager.sharedManager.collegeProfessorList
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
    
    @IBAction func mailReport(_ sender:Any){
        self.viewMailReport =  ViewProfessorMailReport.instanceFromNib() as? ViewProfessorMailReport
        viewMailReport.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width(), height: self.view.height())
        viewMailReport.makeTableCellEdgesRounded()
        viewMailReport.delegate = self
        viewMailReport.labelEmail.text = UserManager.sharedUserManager.appUserDetails.email
        self.view.addSubview(viewMailReport)
    }
    
}


extension CollegeLogsProfessorListViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let professsorList = self.filteredProfessorList{
            return professsorList.professorSubjects.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TeacherDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId, for: indexPath) as! TeacherDetailsTableViewCell
        let details:ProfessorSubject = (self.filteredProfessorList?.professorSubjects[indexPath.section])!
        cell.setUpProfessorLogCellDetails(tempDetails: details, searchText: self.searchText)
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
        let details:ProfessorSubject = (self.filteredProfessorList?.professorSubjects[indexPath.section])!

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let professorLogsListVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorLogs) as! ProfessorLogsListViewController
        professorLogsListVC.isCollegeLogsSubjectData = true
        professorLogsListVC.selectedProfessorName = details.professorName
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

extension CollegeLogsProfessorListViewController:ViewProfessorMailReportDelegate{
    func dismissMailReportView() {
        self.viewMailReport.removeFromSuperview()
    }
    
    func mailReport(fromDate: String, toDate: String) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeAuth
        let profId = self.filteredProfessorList?.professorSubjects.map({$0.professorID ?? "0" })
        let profIdSring = profId?.joined(separator: ",") ?? ""
        //get all the class id and join them using ","
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "email":"\(UserManager.sharedUserManager.appUserDetails.email!)",
            "professor_id":"\(profIdSring)",
            "from_date":fromDate,
            "to_date":toDate,
            ] as [String : Any]
        
        manager.apiPost(apiName: "Send AttendanceReport to email", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                let message:String = response["message"] as! String
                self.viewMailReport.removeFromSuperview()
                self.showAlertWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
}

//MARK:- UISearchBarDelegate
extension CollegeLogsProfessorListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText = \(searchText)")
        self.searchText = searchText
        if !searchText.isEmpty
        {
            filteredProfessorList?.professorSubjects = ProfessorLogsManager.sharedManager.collegeProfessorList?.professorSubjects.filter({
                return $0.professorName?.lowercased().contains(self.searchText.lowercased()) ?? false
            }) ?? []
        }else{
            filteredProfessorList = ProfessorLogsManager.sharedManager.collegeProfessorList
        }
        self.tableViewProfessorName.reloadData()
    }
}

