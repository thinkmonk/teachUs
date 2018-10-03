//
//  CollegeTeachersRatingListViewController.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class CollegeTeachersRatingListViewController: BaseViewController {

    @IBOutlet weak var tableViewCollegeTeachersList: UITableView!
    @IBOutlet weak var buttonPreviousCourse: UIButton!
    @IBOutlet weak var buttonNextCourse: UIButton!

    var ratingClass:RatingClassList!
    var arrayDataSource:[RatingProfessorList] = []
    var arrayClassList:[RatingClassList] = []

    var selectedIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.tableViewCollegeTeachersList.register(UINib(nibName: "ProfessorRatingProfileTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.ProfessorRatingProfileTableViewCellId)
        self.tableViewCollegeTeachersList.delegate = self
        self.tableViewCollegeTeachersList.dataSource = self
        self.tableViewCollegeTeachersList.alpha = 0
        self.tableViewCollegeTeachersList.estimatedRowHeight = 85.0
        self.tableViewCollegeTeachersList.rowHeight = UITableViewAutomaticDimension
        self.tableViewCollegeTeachersList.addSubview(refreshControl)
        self.getRating()
        self.setUpButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func refresh(sender: AnyObject) {
        self.getRating()
        super.refresh(sender: sender)
    }
    
    
    //MARK:Class Methods
    
    func getRating(){
        self.title = "\(self.arrayClassList[self.selectedIndex].courseName) \(self.arrayClassList[self.selectedIndex].classDivision)"
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.ClassProfessorRatingList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "class_id":"\(self.arrayClassList[self.selectedIndex].classId)"
        ]
        
        manager.apiPost(apiName: " Get professor rating list", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let ratingProfesssorListArray = response["prof_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for ratingList in ratingProfesssorListArray{
                let tempList = Mapper<RatingProfessorList>().map(JSONObject: ratingList)
                self.arrayDataSource.append(tempList!)
            }
            self.arrayDataSource.sort(by: { $0.fullname < $1.fullname })
            self.tableViewCollegeTeachersList.reloadData()
            self.showTableView()
            
            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableViewCollegeTeachersList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewCollegeTeachersList.alpha = 1.0
            self.tableViewCollegeTeachersList.transform = CGAffineTransform.identity
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toRatingDetails{
            let destinationVC:CollegeProfessorRatingDetailViewController = segue.destination as! CollegeProfessorRatingDetailViewController
            destinationVC.ratingProfessor = self.arrayDataSource[(self.tableViewCollegeTeachersList.indexPathForSelectedRow?.section)!]
            destinationVC.arrayProfessorList = self.arrayDataSource
            destinationVC.selectedProfessorIndex = (self.tableViewCollegeTeachersList.indexPathForSelectedRow?.section)!
            destinationVC.ratingClass = self.ratingClass
        }
    }
    
    
    //MARK:- NEXT & PREVIOUS SUBJECTS
    
    @IBAction func showRatingForNextCourse(_ sender: Any) {
        if (self.selectedIndex < self.arrayClassList.count-1){
            self.selectedIndex += 1
            self.getRating()
            self.setUpButtons()
        }
    }
    
    @IBAction func showRatingForPreviousCourse(_ sender: Any) {
        if (self.selectedIndex > 0){
            self.selectedIndex -= 1
            self.getRating()
            self.setUpButtons()
        }
    }
    
    func setUpButtons(){
        if  self.selectedIndex == 0 {
            self.buttonPreviousCourse.isEnabled = false
            self.buttonNextCourse.isEnabled = true
        }else if self.selectedIndex == self.arrayClassList.count-1 {
            self.buttonNextCourse.isEnabled = false
            self.buttonPreviousCourse.isEnabled = true
        }else{
            self.buttonNextCourse.isEnabled = true
            self.buttonPreviousCourse.isEnabled = true
        }
    }
}

extension CollegeTeachersRatingListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfessorRatingProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ProfessorRatingProfileTableViewCellId, for: indexPath) as! ProfessorRatingProfileTableViewCell
        let ratingObject:RatingProfessorList = arrayDataSource[indexPath.section]
        cell.labelRatings.text = "\(ratingObject.ratings)"
        cell.labelPopularity.text = "\(ratingObject.popularity)"
        cell.labelSubjectName.text = "\(ratingObject.subjectName)"
        cell.labelProfessorName.text = "\(ratingObject.fullname)"
        cell.imageViewProfessor.imageFromServerURL(urlString: ratingObject.imageUrl, defaultImage: Constants.Images.defaultProfessor)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewCollegeTeachersList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segues.toRatingDetails, sender: self)
    }
    
}
