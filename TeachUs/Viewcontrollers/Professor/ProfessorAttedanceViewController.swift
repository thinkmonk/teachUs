//
//  ProfessorAttedanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import XLPagerTabStrip

class ProfessorAttedanceViewController: BaseViewController {

    var parentNavigationController : UINavigationController?
    var arrayCollegeList:[College]? = []
//    var viewCollegeList:CollegeList!
    
    @IBOutlet weak var tableviewCollegeList: UITableView!
    let nibCollegeListCell = "ProfessorCollegeListTableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfessorAttedanceViewController")
        tableviewCollegeList.delegate = self
        tableviewCollegeList.dataSource = self
        self.tableviewCollegeList.alpha = 0
        self.getCollegeSummaryForProfessor()

        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableviewCollegeList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.ProfessorCollegeList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getCollegeSummaryForProfessor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCollegeSummaryForProfessor(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getClassList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: " Get Professor Class list", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            self.arrayCollegeList?.removeAll()
            guard let colleges = response["class_list"] as? [[String:Any]] else{
                return
            }
            for college in colleges{
                let tempCollege = Mapper<College>().map(JSONObject: college)
                self.arrayCollegeList?.append(tempCollege!)
            }
            UIView.animate(withDuration: 1.0, animations: {
                self.tableviewCollegeList.alpha = 1
            })
            self.tableviewCollegeList.reloadData()

            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }


    }
    func selectedSubject(_ subject: College) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let destinationVC:StudentsListViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentList) as! StudentsListViewController
         destinationVC.subject = subject        
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ProfessorAttedanceViewController:UITableViewDataSource, UITableViewDelegate{
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
            
            collegeCell.labelSubjectName.text = self.arrayCollegeList![indexPath.section].subjectName
            collegeCell.selectionStyle = UITableViewCellSelectionStyle.none
            cell = collegeCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewCollegeList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSubject(self.arrayCollegeList![indexPath.section])
    }
}

extension ProfessorAttedanceViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance")
    }
}
