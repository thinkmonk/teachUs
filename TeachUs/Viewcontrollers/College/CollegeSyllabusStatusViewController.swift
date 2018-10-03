//
//  CollegeSyllabusStatusViewController.swift
//  TeachUs
//
//  Created by ios on 3/18/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper

class CollegeSyllabusStatusViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    var arrayDataSource:[CollegeSyllabusList] = []
    @IBOutlet weak var tableviewCollegeSyllabus: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewCollegeSyllabus.register(UINib(nibName: "CollegeSyllabusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.CollegeSyllabusTableViewCellId)
        self.tableviewCollegeSyllabus.delegate = self
        self.tableviewCollegeSyllabus.dataSource = self
        self.tableviewCollegeSyllabus.alpha = 0.0
        self.tableviewCollegeSyllabus.addSubview(refreshControl)
        getClassSyllabus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresh(sender: AnyObject) {
        self.getClassSyllabus()
        super.refresh(sender: sender)
    }
    
    func getClassSyllabus(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getCollegeSyllabusList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)"
        ]
        
        manager.apiPost(apiName: " Get Class Syllabus", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let ratingListArray = response["class_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for ratingList in ratingListArray{
                let tempList = Mapper<CollegeSyllabusList>().map(JSONObject: ratingList)
                self.arrayDataSource.append(tempList!)
            }
            self.arrayDataSource.sort(by: { $0.courseName < $1.courseName })

            self.tableviewCollegeSyllabus.reloadData()
            self.showTableView()
            
            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableviewCollegeSyllabus.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableviewCollegeSyllabus.alpha = 1.0
            self.tableviewCollegeSyllabus.transform = CGAffineTransform.identity
        }
    }

}

extension CollegeSyllabusStatusViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CollegeSyllabusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.CollegeSyllabusTableViewCellId, for: indexPath) as! CollegeSyllabusTableViewCell
        cell.labelSyllabusSubject.text = self.arrayDataSource[indexPath.section].courseName
        cell.labelSyllabusPercent.text = "\(self.arrayDataSource[indexPath.section].status)%"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewCollegeSyllabus.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let professorSyllabusStatusVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
        professorSyllabusStatusVC.title = "\(self.arrayDataSource[indexPath.section].courseName)"
        professorSyllabusStatusVC.parentNavigationController = self.parentNavigationController
        professorSyllabusStatusVC.userType = LoginUserType.College
        professorSyllabusStatusVC.selectedClassId = self.arrayDataSource[indexPath.section].classId
        self.navigationController?.pushViewController(professorSyllabusStatusVC, animated: true)
    }
}

extension CollegeSyllabusStatusViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Syllabus")
    }
}

