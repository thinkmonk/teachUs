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

class ProfessorLogsListViewController: UIViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[College]! = []
    @IBOutlet weak var tableviewLogs: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfessorLogsListViewController")
        self.tableviewLogs.backgroundColor = UIColor.clear
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewLogs.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)
        self.tableviewLogs.estimatedRowHeight = 44.0
        self.tableviewLogs.alpha = 0
        self.tableviewLogs.rowHeight = UITableViewAutomaticDimension
        self.getLogs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLogs(){
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getClassList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: "Get professor logs", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let logs = response["class_list"] as? [[String:Any]] else{
                return
            }
            for log in logs{
                let tempLog = Mapper<College>().map(JSON: log)
                self.arrayDataSource.append(tempLog!)
            }
            self.makeTableView()
            self.showTableView()
        }) { (success, code, mesage) in
            LoadingActivityHUD.hideProgressHUD()
            print(mesage)
        }

    }
    
    func makeTableView(){
        print(self.arrayDataSource)
        self.tableviewLogs.delegate = self
        self.tableviewLogs.dataSource = self
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
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(cell == nil){
            let collegeCell:ProfessorCollegeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorCollegeList, for: indexPath) as! ProfessorCollegeListTableViewCell
            
            collegeCell.labelSubjectName.text = self.arrayDataSource[indexPath.section].subjectName
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            cell = collegeCell
        }
        return cell
    }
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return self.arrayDataSource[section].name
     }
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        
        let labelTitle = UILabel(frame: CGRect(x: 15.0, y: headerView.height()/2, width: headerView.width()-15, height: 15))
        labelTitle.center.y = headerView.centerY()
        labelTitle.textAlignment = .left
        labelTitle.textColor = UIColor.white
        labelTitle.text = ""
        labelTitle.font = UIFont.systemFont(ofSize: 14.0)
        labelTitle.numberOfLines = 0
        headerView.addSubview(labelTitle)
        
        headerView.backgroundColor = UIColor.rgbColor(52, 40, 70)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
        return IndicatorInfo(title: "Logs")
    }
}

