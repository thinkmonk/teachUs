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
    var arrayDataSource:CollegeSyllabusList?
    @IBOutlet weak var tableviewCollegeSyllabus: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewCollegeSyllabus.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
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
        
        manager.apiPostWithDataResponse(apiName: " Get Class Syllabus", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.arrayDataSource = try decoder.decode(CollegeSyllabusList.self, from: response)
                self.arrayDataSource?.classList.sort(by: { $0.courseName ?? "" < $1.courseName ?? "" })
            }catch let error{
                print("parsing error \(error)")
            }
            

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
        return self.arrayDataSource?.classList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath) as! SyllabusStatusTableViewCell
        cell.labelSubject.text = self.arrayDataSource?.classList[indexPath.section].courseName
        //***********************************************************************************
        //*** Interchanging number of lectures and syllabus % text to suit the required UI***
        //***********************************************************************************
        cell.labelNumberOfLectures.text = "\(self.arrayDataSource?.classList[indexPath.section].status.stringValue ?? "0")%"
        cell.labelAttendancePercent.text = "\(self.arrayDataSource?.classList[indexPath.section].numberOfLectures ?? "NA")"
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
        if let classObj = self.arrayDataSource?.classList[indexPath.section], let classID = classObj.classId{
            professorSyllabusStatusVC.title = "\(classObj.courseName)"
            professorSyllabusStatusVC.parentNavigationController = self.parentNavigationController
            professorSyllabusStatusVC.userType = LoginUserType.College
            professorSyllabusStatusVC.selectedClassId = classID
            self.navigationController?.pushViewController(professorSyllabusStatusVC, animated: true)
        }
    }
}

extension CollegeSyllabusStatusViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Syllabus")
    }
}

