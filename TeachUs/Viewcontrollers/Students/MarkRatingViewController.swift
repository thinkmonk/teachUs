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
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
        DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
        DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
        DotColors(first: color(0xE9A966), second: color(0xF8C852)),
        DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
    ]
    
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
        self.tableViewTeacherRating.backgroundColor = .clear
        self.butonSubmit.alpha = 0
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
            ratingTemp["criteria_id"] = "\(value.criteriaId)"
            ratingTemp["criteria_value"] = "\(value.ratings)"
            ratings.append(ratingTemp)
        }
        var requestString = ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: ratings,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        
        let teacherPoularString:String = self.isTeacherPopular ? "1" : "0"
        
        let parameters: [String: Any] = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "professor_id":"\(self.professsorDetails.professorId)",
            "subject_id":"\(self.subjectId)",
            "role_id":"1",
            "like":"\(teacherPoularString)",
            "ratings":requestString
        ]
        
        manager.url = URLConstants.StudentURL.updateRatings 
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
            profileCell.labelteacherName.text = self.professsorDetails.professforFullname
            profileCell.labelTeacherSubject.text = self.professsorDetails.subjectName
            profileCell.imageViewProfile.imageFromServerURL(urlString: self.professsorDetails.imageURL, defaultImage: Constants.Images.defaultProfessor)
            profileCell.selectionStyle = .none
            profileCell.imageViewProfile.makeViewCircular()
            profileCell.buttonHeart.indexPath = indexPath
            profileCell.buttonHeart.delegate = self
            if(self.isTeacherPopular){
                profileCell.buttonHeart.isSelected = true
            }
            //            profileCell.buttonHeart.addTarget(self, action: #selector(MarkRatingViewController.markTeacherPopular(_:)), for: .touchUpInside)
            return profileCell
            
        case .RatingTitle:
            let ratingTitleCell :RatingTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTitleTableViewCellId, for: indexPath) as! RatingTitleTableViewCell
            ratingTitleCell.selectionStyle = .none
            ratingTitleCell.backgroundColor = .clear
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewTeacherRating.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section > 1){
            return 15
        }
        return 0
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
            return 44
            
        case .RatingTopics:
            return 50
        }
        
    }
    
    @objc func markTeacherPopular(_ sender: FaveButton){
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
            print( "\(self.arrayDataSource[sender.indexPath.section-2].ratings )  is  \( self.arrayDataSource[sender.indexPath.section-2].criteria)" )
            self.tableViewTeacherRating.reloadRows(at: [sender.indexPath], with: .fade)
            var allRatingsGiven:Bool = true
            for tempRating in self.arrayDataSource{
                if tempRating.ratings == ""{
                    allRatingsGiven = false
                    break
                }
            }
            self.butonSubmit.alpha = allRatingsGiven ? 1 : 0
        }
        self.ratingDropDown.show()
    }
    
    @objc func showInfo(_ sender: ButtonWithIndexPath){
        let viewRating = ViewRatingInfo.instanceFromNib() as! ViewRatingInfo
        if(!arrayDataSource[sender.indexPath.row].description.isEmpty){
            viewRating.labelRatingDetails.text = self.arrayDataSource[sender.indexPath.row].description
        }
        else{
            viewRating.labelRatingDetails.text = "NA"
            
        }
        viewRating.showView(inView: self.view)
    }
}

extension MarkRatingViewController:FaveButtonDelegate{
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        return colors
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
        print("selected vc \(selected)")
        self.isTeacherPopular = !self.isTeacherPopular
        //        self.tableViewTeacherRating.reloadRows(at: [faveButton.indexPath], with: .automatic)
        
    }
    
    
}

