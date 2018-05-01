//
//  MarkRatingViewController.swift
//  TeachUs
//
//  Created by ios on 11/23/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class MarkRatingViewController: BaseViewController {
    var parentNavigationController : UINavigationController?

    var arrayDataSource:[ProfessorRatingDetials] = []
    var professsorDetails:ProfessorDetails!
    var subjectId:String = ""
    var arrayTableDataSource:[RatingDataSource] = []
    var ratingDropDown = DropDown()
    var isTeacherPopular:Bool = false
    @IBOutlet weak var tableViewTeacherRating: UITableView!
    @IBOutlet weak var butonSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTeacherRating.register(UINib(nibName: "TeacherProfileTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.TeacherProfileTableViewCellId)
        self.tableViewTeacherRating.register(UINib(nibName: "RatingTitleTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.RatingTitleTableViewCellId)
        self.tableViewTeacherRating.register(UINib(nibName: "RatingTopicsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.RatingTopicsTableViewCellId)
        self.makeDataSource()
        self.tableViewTeacherRating.delegate = self
        self.tableViewTeacherRating.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.butonSubmit.themeRedButton()
        self.butonSubmit.makeViewCircular()
        self.addGradientToNavBar()
    }
    
    func makeDataSource(){
        arrayTableDataSource.removeAll()
        
        let profileDataSource = RatingDataSource(celType: .TeacherProfile, attachedObject: professsorDetails)
        profileDataSource.isSelected = false
        arrayTableDataSource.append(profileDataSource)
        
        let titleDataSource = RatingDataSource(celType: .RatingTitle, attachedObject: nil)
        titleDataSource.isSelected = false
        arrayTableDataSource.append(titleDataSource)
        
        
        for topic in self.arrayDataSource{
            let topicsDataSource = RatingDataSource(celType: .RatingTopics, attachedObject: topic)
            topicsDataSource.isSelected = false
            arrayTableDataSource.append(topicsDataSource)
        }
        self.tableViewTeacherRating.reloadData()
    }
    
    
    @IBAction func submitFeedback(_ sender: Any) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()

        var ratings:[[String:Any]]! = []
        for value in self.arrayDataSource{
            var ratingTemp:[String:Any] = [:]
            ratingTemp["criteriaId"] = "\(value.criteriaId)"
            ratingTemp["rating"] = "\(value.ratings)"
            ratings.append(ratingTemp)
        }
        let teacherPoularString:String = self.isTeacherPopular ? "YES" : "NO"
        
        let parameters: [String: Any] = [
            "studentId":"\(UserManager.sharedUserManager.getUserId())",
            "professorId":"\(self.professsorDetails.professorId!)",
            "subjectId":"\(self.subjectId)",
            "popular":"\(teacherPoularString)",
            "teacherRating":ratings
        ]
        
        manager.url = URLConstants.StudentURL.updateRatings +
//            "\(UserManager.sharedUserManager.getAccessToken())" +
        "==?studentId=\(UserManager.sharedUserManager.userStudent.studentId)"
//        manager.url = URLConstants.BaseUrl.baseURL + UserManager.sharedUserManager.userStudent.ratingsUrl!
        manager.apiPost(apiName: "Submit teacher Rating", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            DispatchQueue.main.async(execute: {() -> Void in
                self.navigationController?.popViewController(animated: true)
            })
        }) { (result, code, errorString) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorString)
        }
    }
}

extension MarkRatingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayTableDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayTableDataSource[indexPath.section]
        switch cellDataSource.ratingCellType!{
        case .TeacherProfile:
            let profileCell:TeacherProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.TeacherProfileTableViewCellId, for: indexPath) as! TeacherProfileTableViewCell
            profileCell.labelteacherName.text = self.professsorDetails.professorName
            profileCell.labelTeacherSubject.text = self.professsorDetails.subjectName
            profileCell.imageViewProfile.imageFromServerURL(urlString: self.professsorDetails.imageURL!, defaultImage: Constants.Images.defaultProfessor)
            profileCell.selectionStyle = .none
            profileCell.imageViewProfile.makeViewCircular()
            profileCell.buttonHeart.indexPath = indexPath
            if(self.isTeacherPopular){
                profileCell.buttonHeart.isSelected = true
            }
            profileCell.buttonHeart.addTarget(self, action: #selector(MarkRatingViewController.markTeacherPopular(_:)), for: .touchUpInside)
            return profileCell
        
        case .RatingTitle:
            let ratingTitleCell :RatingTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTitleTableViewCellId, for: indexPath) as! RatingTitleTableViewCell
            ratingTitleCell.selectionStyle = .none
            return ratingTitleCell
        case .RatingTopics:
            let cell : RatingTopicsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTopicsTableViewCellId, for: indexPath) as! RatingTopicsTableViewCell
            
            let details:ProfessorRatingDetials = self.arrayDataSource[indexPath.section - 2] //-2 is fot the top to sections cells i.e. profile & title
 
            cell.labelRatingTopic.text = "\(details.criteria)"
            cell.buttonRating.setTitle("\(details.ratings)", for: .normal)
            cell.buttonRating.indexPath = indexPath
            cell.buttonShowInfo.indexPath = indexPath
            cell.buttonShowInfo.addTarget(self, action: #selector(MarkRatingViewController.showInfo(_:)), for: .touchUpInside)
            
            cell.buttonRating.addTarget(self, action: #selector(MarkRatingViewController.showRating(_:)), for: .touchUpInside)
            cell.makeWhiteBackground(false)

            cell.selectionStyle = .none
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewTeacherRating.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellDataSource = arrayTableDataSource[indexPath.section]
        switch cellDataSource.ratingCellType! {
        case .TeacherProfile:
            return 100

        case .RatingTitle:
            return 50
            
        case .RatingTopics:
            return 50
        }

    }
    
    @objc func markTeacherPopular(_ sender: ButtonWithIndexPath){
        self.isTeacherPopular = !self.isTeacherPopular
        self.tableViewTeacherRating.reloadRows(at: [sender.indexPath], with: .automatic)
    }
    
    @objc func showRating(_ sender: ButtonWithIndexPath){
        
        let cell:RatingTopicsTableViewCell = self.tableViewTeacherRating.cellForRow(at: sender.indexPath) as! RatingTopicsTableViewCell
        
        
        self.ratingDropDown.bottomOffset = CGPoint(x: 0, y: cell.height())
        ratingDropDown.anchorView = cell.buttonRating
        self.ratingDropDown.dataSource = [
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10"
        ]
        
        self.ratingDropDown.selectionAction = { [unowned self] (index, item) in
            self.arrayDataSource[sender.indexPath.section-2].ratings = item
            self.tableViewTeacherRating.reloadRows(at: [sender.indexPath], with: .fade)

        }
        self.ratingDropDown.show()
    }
    
    @objc func showInfo(_ sender: ButtonWithIndexPath){
        let viewRating = ViewRatingInfo.instanceFromNib() as! ViewRatingInfo
        viewRating.labelRatingDetails.text = self.arrayDataSource[sender.indexPath.section].description
        viewRating.showView(inView: self.view)
    }
}
