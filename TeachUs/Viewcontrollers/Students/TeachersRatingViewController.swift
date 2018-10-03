//
//  TeachersRatingViewController.swift
//  TeachUs
//
//  Created by ios on 11/21/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper

class TeachersRatingViewController: BaseViewController {

    @IBOutlet weak var tableViewTeachersList: UITableView!
    var parentNavigationController : UINavigationController?

    var arrayDataSource:[ProfessorDetails] = []
    var arrayRatingCriteriaDataSource:[ProfessorRatingDetials] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTeachersList.register(UINib(nibName: "TeacherDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId)
        self.tableViewTeachersList.estimatedRowHeight = 90
        self.tableViewTeachersList.rowHeight  = UITableViewAutomaticDimension
        self.tableViewTeachersList.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableViewTeachersList.alpha = 0
        self.getRatings()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func refresh(sender: AnyObject) {
        self.getRatings()
        super.refresh(sender: sender)
    }
    
    func getRatings(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.professorRatingList
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"1"
        ]
        
        
        manager.apiPost(apiName: "Get ratings for professor", parameters: parameters, completionHandler: { (success, code, response) in
            LoadingActivityHUD.hideProgressHUD()

            guard let teachers = response["prof_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for teacher in teachers{
                let tempteacher = Mapper<ProfessorDetails>().map(JSON: teacher)
                self.arrayDataSource.append(tempteacher!)
            }
            self.arrayDataSource.sort(by: { $0.professforFullname < $1.professforFullname })
//            guard let ratingCriteria = response["rating_list"] as? [String:Any] else{
//                return
//            }
            
            guard let criteriaList = response["rating_list"] as? [[String:Any]] else{
                return
            }
            self.arrayRatingCriteriaDataSource.removeAll()
            for criteria in criteriaList{
                let tempCriteria = Mapper<ProfessorRatingDetials>().map(JSON: criteria)
                self.arrayRatingCriteriaDataSource.append(tempCriteria!)
            }
            
            
            self.makeTableView()
        }) { (success, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)

        }
    }

    func makeTableView(){
        self.tableViewTeachersList.delegate = self
        self.tableViewTeachersList.dataSource = self
        self.tableViewTeachersList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewTeachersList.alpha = 1.0
            self.tableViewTeachersList.transform = CGAffineTransform.identity
        }
        self.tableViewTeachersList.reloadData()

    }
}


extension TeachersRatingViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TeacherDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId, for: indexPath) as! TeacherDetailsTableViewCell
        let details:ProfessorDetails = self.arrayDataSource[indexPath.section]
                cell.setUpCellDetails(tempDetails: details)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewTeachersList.width(), height: 15))
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
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewTeachersList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:MarkRatingViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.MarkRating) as! MarkRatingViewController
        destinationVC.arrayDataSource = self.arrayRatingCriteriaDataSource
        destinationVC.professsorDetails = self.arrayDataSource[indexPath.section]
        destinationVC.subjectId = "\(self.arrayDataSource[indexPath.section].subjectId)"
        destinationVC.parentNavigationController = self.parentNavigationController
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }    
}

extension TeachersRatingViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Rating")
    }
}
