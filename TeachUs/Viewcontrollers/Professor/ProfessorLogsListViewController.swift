//
//  LogsListViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import XLPagerTabStrip

class ProfessorLogsListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[College]! = []
    @IBOutlet weak var tableviewLogs: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"
    
    
    var isCollegeLogsSubjectData:Bool = false //for college logs
    var selectedProffessorId:String? //for college logs
    var arraySubjectList:ProfessorSubjectList! //for college logs
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewLogs.backgroundColor = UIColor.clear
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewLogs.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)
        self.tableviewLogs.estimatedRowHeight = 44.0
        self.tableviewLogs.alpha = 0
        self.tableviewLogs.rowHeight = UITableViewAutomaticDimension
        self.tableviewLogs.delegate = self
        self.tableviewLogs.dataSource = self

        if(isCollegeLogsSubjectData){
            self.addGradientToNavBar()
            self.getCollegeLogsSubjectData()
        }else{
            self.getLogs()
        }
        tableviewLogs.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresh(sender: AnyObject) {
        if(self.isCollegeLogsSubjectData){
            self.getCollegeLogsSubjectData()
        }else{
            self.getLogs()
        }
        super.refresh(sender:sender) //this wil end the refreshing
    }

    func getCollegeLogsSubjectData(){ //for college logs
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getLogsSubjectData
        if let profId = self.selectedProffessorId{
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "professor_id":"\(profId)"
            ]
            
            
            manager.apiPostWithDataResponse(apiName: "Get professor logs for college", parameters: parameters, completionHandler: { (result, code, response) in
                LoadingActivityHUD.hideProgressHUD()
                if(code == 200){
                    do{
                        let decoder = JSONDecoder()
                        self.arraySubjectList = try decoder.decode(ProfessorSubjectList.self, from: response)
                        self.arraySubjectList.subjectsDetails.sort(by: { $0.subjectName < $1.subjectName })
                    }
                    catch let error{
                        print("err", error)
                    }
                }
                else{
                    print("Error in fetching data")
                }
                self.makeTableView()
                self.showTableView()
            }) { (success, code, mesage) in
                LoadingActivityHUD.hideProgressHUD()
                print(mesage)
            }
        }
        
    }
    
    
    func getLogs(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url =  URLConstants.ProfessorURL.getClassList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: "Get professor logs", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let logs = response["class_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for log in logs{
                let tempLog = Mapper<College>().map(JSON: log)
                self.arrayDataSource.append(tempLog!)
            }
            self.arrayDataSource.sort(by: { ($0.year!,$0.classDivision! ,$0.subjectName!) < ($1.year!,$0.classDivision!,$1.subjectName!) })
            
            self.makeTableView()
            self.showTableView()
        }) { (success, code, mesage) in
            LoadingActivityHUD.hideProgressHUD()
            print(mesage)
        }
    }
    
    func makeTableView(){
        print(self.arrayDataSource)
        self.tableviewLogs.reloadData()
    }
    
    func showTableView(){
        self.tableviewLogs.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableviewLogs.alpha = 1.0
            self.tableviewLogs.transform = CGAffineTransform.identity
        }
    }
}

extension ProfessorLogsListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.isCollegeLogsSubjectData && self.arraySubjectList != nil){
            return self.arraySubjectList.subjectsDetails.count
        }else if(self.arrayDataSource!.count != 0){
            return self.arrayDataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(cell == nil){
            let collegeCell:ProfessorCollegeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorCollegeList, for: indexPath) as! ProfessorCollegeListTableViewCell
            if(self.isCollegeLogsSubjectData){
                collegeCell.labelSubjectName.text = "\(self.arraySubjectList.subjectsDetails[indexPath.section].subjectName)"
                collegeCell.isUserInteractionEnabled =  false

            }
            else{
                collegeCell.labelSubjectName.text = "\(self.arrayDataSource![indexPath.section].yearName!)\(self.arrayDataSource![indexPath.section].courseCode!) - \(self.arrayDataSource![indexPath.section].subjectName!) - \(self.arrayDataSource![indexPath.section].classDivision!)"
                collegeCell.isUserInteractionEnabled =  true

            }
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            collegeCell.accessoryType = .disclosureIndicator
            cell = collegeCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewLogs.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewLogs.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:LogsDetailViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.LogsDetail) as! LogsDetailViewController
        destinationVC.selectedCollege = self.arrayDataSource[indexPath.section]
        destinationVC.allCollegeArray = self.arrayDataSource
        destinationVC.selectedIndex = indexPath.section
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ProfessorLogsListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Logs")
    }
}

