//
//  CollegeProfessorRatingDetailViewController.swift
//  TeachUs
//
//  Created by ios on 4/21/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class CollegeProfessorRatingDetailViewController: BaseViewController {

    var ratingProfessor:RatingProfessorList!
    var ratingClass:RatingClassList!
    var arrayProfessorDetailsList:[ProfessorRatingDetials] = []
    var arrayTableDataSource:[RatingDataSource] = []
    
    var arrayProfessorList:[RatingProfessorList] = []
    var selectedProfessorIndex = 0
    
    @IBOutlet weak var buttonPreviousProfessor: UIButton!
    @IBOutlet weak var buttonNextProfessor: UIButton!


    @IBOutlet weak var tableViewRatingDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewRatingDetail.register(UINib(nibName: "TeacherProfileTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TeacherProfileTableViewCellId)
        self.tableViewRatingDetail.register(UINib(nibName: "RatingTitleTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.RatingTitleTableViewCellId)
        self.tableViewRatingDetail.register(UINib(nibName: "RatingTopicsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.RatingTopicsTableViewCellId)

        self.getRatingDetails()
        self.tableViewRatingDetail.delegate = self
        self.tableViewRatingDetail.dataSource = self
        self.tableViewRatingDetail.alpha = 0
        self.addGradientToNavBar()
        self.setUpButtons()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRatingDetails(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getProfessorRatingDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "subject_id":"\(self.arrayProfessorList[self.selectedProfessorIndex].subjectId)",
            "professor_id":"\(self.arrayProfessorList[self.selectedProfessorIndex].professorId)"
            
        ]
        
        manager.apiPost(apiName: " Get rating details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let ratingProfesssorDetailsListArray = response["criteria_list"] as? [[String:Any]] else{
                return
            }
            self.arrayProfessorDetailsList.removeAll()
            for ratingList in ratingProfesssorDetailsListArray{
                let tempList = Mapper<ProfessorRatingDetials>().map(JSONObject: ratingList)
                self.arrayProfessorDetailsList.append(tempList!)
            }
            
            self.makeDataSource()
            
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func makeDataSource(){
        arrayTableDataSource.removeAll()
        
        let profileDataSource = RatingDataSource(celType: .TeacherProfile, attachedObject: self.ratingProfessor)
        profileDataSource.isSelected = false
        arrayTableDataSource.append(profileDataSource)
        
        let titleDataSource = RatingDataSource(celType: .RatingTitle, attachedObject: nil)
        titleDataSource.isSelected = false
        arrayTableDataSource.append(titleDataSource)
        
        
        for topic in self.arrayProfessorDetailsList{
            let topicsDataSource = RatingDataSource(celType: .RatingTopics, attachedObject: topic)
            topicsDataSource.isSelected = false
            arrayTableDataSource.append(topicsDataSource)
        }
        self.tableViewRatingDetail.reloadData()
        self.showTableView()
    }
    
    func showTableView(){
        self.tableViewRatingDetail.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewRatingDetail.alpha = 1.0
            self.tableViewRatingDetail.transform = CGAffineTransform.identity
        }
    }
    //MARK:- Previous & Next Professor
    
    
    @IBAction func showRatingForNextProfessor(_ sender: Any) {
        if (self.selectedProfessorIndex < self.arrayProfessorList.count-1){
            self.selectedProfessorIndex += 1
            self.getRatingDetails()
            self.setUpButtons()
        }
    }
    
    @IBAction func showRatingForPreviousProfessor(_ sender: Any) {
        if (self.selectedProfessorIndex > 0){
            self.selectedProfessorIndex -= 1
            self.getRatingDetails()
            self.setUpButtons()
        }
    }
    
    
    
    
    func setUpButtons(){
        if  self.selectedProfessorIndex == 0 {
            self.buttonPreviousProfessor.isEnabled = false
            self.buttonNextProfessor.isEnabled = true
        }else if self.selectedProfessorIndex == self.arrayProfessorList.count-1 {
            self.buttonNextProfessor.isEnabled = false
            self.buttonPreviousProfessor.isEnabled = true
        }else{
            self.buttonNextProfessor.isEnabled = true
            self.buttonPreviousProfessor.isEnabled = true
        }
    }
}

extension CollegeProfessorRatingDetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayTableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayTableDataSource[indexPath.section]
        switch cellDataSource.ratingCellType!{
        case .TeacherProfile:
            let profileCell:TeacherProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TeacherProfileTableViewCellId, for: indexPath) as! TeacherProfileTableViewCell
            profileCell.labelteacherName.text = self.ratingProfessor.fullname
            profileCell.labelTeacherSubject.text = self.ratingProfessor.subjectName
            profileCell.imageViewProfile.imageFromServerURL(urlString: self.ratingProfessor.imageUrl, defaultImage: Constants.Images.defaultProfessor)
            profileCell.selectionStyle = .none
            profileCell.imageViewProfile.makeViewCircular()
            profileCell.buttonHeart.indexPath = indexPath
            profileCell.buttonHeart.isSelected = true
            profileCell.labelHeartDescription.text = "Popularity"
            if(Int(self.ratingProfessor.popularity) ?? 0 > 0){
                profileCell.labelPopularityValue.alpha = 1
                profileCell.labelPopularityValue.text = "\(self.ratingProfessor.popularity)"
            }
            profileCell.buttonHeart.isEnabled = false
            return profileCell
            
        case .RatingTitle:
            let ratingTitleCell :RatingTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTitleTableViewCellId, for: indexPath) as! RatingTitleTableViewCell
            ratingTitleCell.selectionStyle = .none
            ratingTitleCell.backgroundColor = UIColor.clear
            return ratingTitleCell
            
            
        case .RatingTopics:
            let cell : RatingTopicsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTopicsTableViewCellId, for: indexPath) as! RatingTopicsTableViewCell
            
            let details:ProfessorRatingDetials = self.arrayProfessorDetailsList[indexPath.section-2] //-2 is fot the top to sections cells i.e. profile & title
            
            cell.labelRatingTopic.text = "\(details.criteria)"
            cell.buttonRating.setTitle("\(details.ratings)", for: .normal)
            cell.buttonRating.indexPath = indexPath
            cell.buttonShowInfo.indexPath = indexPath
            cell.buttonShowInfo.alpha = 0
            cell.makeWhiteBackground(true)
            cell.buttonRating.isEnabled = false
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section <= 1){
            return 0
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewRatingDetail.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewRatingDetail.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellDataSource = arrayTableDataSource[indexPath.section]
        switch cellDataSource.ratingCellType! {
        case .TeacherProfile:
            return 100
            
        case .RatingTitle:
            return 40
            
        case .RatingTopics:
            return 50
        }
        
    }
    
}
