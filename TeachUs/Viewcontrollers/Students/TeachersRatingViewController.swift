//
//  TeachersRatingViewController.swift
//  TeachUs
//
//  Created by ios on 11/21/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class TeachersRatingViewController: BaseViewController {

    @IBOutlet weak var tableViewTeachersList: UITableView!
    var parentNavigationController : UINavigationController?

    var arrayDataSource:[ProfessorDetails] = []
    var arrayRatingCriteriaDataSource:[RatingDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTeachersList.register(UINib(nibName: "TeacherDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TeacherDetailsTableViewCellId)
        self.getRatings()
        self.tableViewTeachersList.alpha = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getRatings(){
        let manager = NetworkHandler()

        //http://ec2-34-215-84-223.us-west-2.compute.amazonaws.com:8081/teachus/student/getRatingsSummary/Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x?studentId=1
        
        manager.url = URLConstants.StudentURL.getRatingsSummary +
            "\(UserManager.sharedUserManager.getAccessToken())" +
        "?studentId=\(UserManager.sharedUserManager.getUserId())"
        
        manager.apiGet(apiName: "Get Attendance for student", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let teachers = response["professorWise"] as? [[String:Any]] else{
                return
            }
            
            for teacher in teachers{
                let tempteacher = Mapper<ProfessorDetails>().map(JSON: teacher)
                self.arrayDataSource.append(tempteacher!)
            }
            
            guard let ratingCriteria = response["lookUpRatingCriteria"] as? [String:Any] else{
                return
            }
            
            guard let criteriaList = ratingCriteria["teacherRating"] as? [[String:Any]] else{
                return
            }
            
            for criteria in criteriaList{
                let tempCriteria = Mapper<RatingDetails>().map(JSON: criteria)
                self.arrayRatingCriteriaDataSource.append(tempCriteria!)
            }
            
            
            self.makeTableView()
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
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
        
        cell.imageViewBackground.makeEdgesRoundedWith(radius: cell.imageViewBackground.height()/2)
        cell.imageProfessor.makeEdgesRoundedWith(radius: cell.imageProfessor.height()/2)
        if(arrayDataSource[indexPath.section].isRatingSubmitted! == "true"){
            cell.imageViewBackground.backgroundColor = UIColor.red
            cell.labelName.textColor = UIColor.red
            cell.labelSubject.textColor = UIColor.red
        }
        
        
        cell.labelSubject.text = self.arrayDataSource[indexPath.section].subjectName
        cell.labelName.text = "\(self.arrayDataSource[indexPath.section].professorName!) \(self.arrayDataSource[indexPath.section].professorLastName!)"
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:MarkRatingViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.MarkRating) as! MarkRatingViewController
        destinationVC.arrayDataSource = self.arrayRatingCriteriaDataSource
        destinationVC.professsorDetails = self.arrayDataSource[indexPath.section]
        self.parentNavigationController?.pushViewController(destinationVC, animated: true)
    }    
}
