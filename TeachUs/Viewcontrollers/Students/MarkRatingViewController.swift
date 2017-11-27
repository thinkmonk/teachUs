//
//  MarkRatingViewController.swift
//  TeachUs
//
//  Created by ios on 11/23/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class MarkRatingViewController: BaseViewController {

    var arrayDataSource:[RatingDetails] = []
    var professsorDetails:ProfessorDetails!
    var arrayTableDataSource:[RatingDataSource] = []
    var ratingDropDown = DropDown()
    
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
        self.butonSubmit.makeEdgesRounded()
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
            return profileCell
        
        case .RatingTitle:
            let ratingTitleCell :RatingTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTitleTableViewCellId, for: indexPath) as! RatingTitleTableViewCell
            ratingTitleCell.selectionStyle = .none
            return ratingTitleCell
        case .RatingTopics:
            let cell : RatingTopicsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.RatingTopicsTableViewCellId, for: indexPath) as! RatingTopicsTableViewCell
            
            let details:RatingDetails = self.arrayDataSource[indexPath.section - 2] //-2 is fot the top to sections cells i.e. profile & title
 
            cell.labelRatingTopic.text = "\(details.criteria!)"
            cell.buttonRating.setTitle("\(details.rating!)", for: .normal)
            cell.buttonRating.indexPath = indexPath
            cell.buttonShowInfo.indexPath = indexPath
            cell.buttonShowInfo.addTarget(self, action: #selector(MarkRatingViewController.showInfo(_:)), for: .touchUpInside)
            
            cell.buttonRating.addTarget(self, action: #selector(MarkRatingViewController.showRating(_:)), for: .touchUpInside)
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
            self.arrayDataSource[sender.indexPath.section-2].rating = item
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
