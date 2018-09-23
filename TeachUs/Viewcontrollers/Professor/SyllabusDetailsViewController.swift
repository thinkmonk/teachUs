//
//  SyllabusDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 11/19/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class SyllabusDetailsViewController: BaseViewController {
    @IBOutlet weak var labelCompletionStatus: UILabel!
    @IBOutlet weak var tableSyllabusDetails: UITableView!
    var arrayDataSource:[Unit] = []
    var completionStatus:String = ""
    var selectedSubject:Subject!
    var userType:LoginUserType!
    var selectedClassId:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSyllabusDetails.register(UINib(nibName: "SyllabusDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId)
        self.tableSyllabusDetails.delegate = self
        self.tableSyllabusDetails.dataSource = self
        self.tableSyllabusDetails.alpha = 0;
        self.getSyllabusDetails()
        self.labelCompletionStatus.text = "Completion: \(self.completionStatus)"
        self.tableSyllabusDetails.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresh(sender: AnyObject) {
        self.getSyllabusDetails()
        super.refresh(sender: sender)
    }
    
    func getSyllabusDetails(){
        let manager = NetworkHandler()
        var parameters = [String:Any]()
        parameters["subject_id"] = "\(selectedSubject.subjectId)"
        parameters["college_code"] = UserManager.sharedUserManager.appUserCollegeDetails.college_code

        switch self.userType! {
        case .Professor:
            manager.url = URLConstants.ProfessorURL.getSyllabusSuubjectDetails
            parameters["class_id"] = "\(selectedSubject.classId)"

            break
        case .College:
            manager.url  = URLConstants.CollegeURL.getCollegeSubjectSyllabusDetails
            parameters["class_id"] = "\(self.selectedClassId)"

            break
        case .Student:
            manager.url = URLConstants.StudentURL.getSyllabusSuubjectDetails
            break
        }
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)

        manager.apiPost(apiName: "Get Syllabus  details for professor", parameters: parameters, completionHandler: { (sucess, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            
            guard let completionPercent:String = response["syllabus_percentage"] as? String else{
                return
            }
            self.labelCompletionStatus.text = "Completion:\(completionPercent)%"
            
            guard let subjects = response["unit_syllabus_array"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for subject in subjects{
                let tempSubject = Mapper<Unit>().map(JSON: subject)
                self.arrayDataSource.append(tempSubject!)
            }
            self.tableSyllabusDetails.reloadData()
            self.showTableView()
            
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
            
        }
    }
    
    func showTableView(){
        self.tableSyllabusDetails.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableSyllabusDetails.alpha = 1.0
            self.tableSyllabusDetails.transform = CGAffineTransform.identity
        }
    }
}



extension SyllabusDetailsViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayDataSource[section].topicArray?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SyllabusDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusDetailsTableViewCellId, for: indexPath) as! SyllabusDetailsTableViewCell
        let chapter = self.arrayDataSource[indexPath.section].topicArray![indexPath.row]
        cell.labelChapterDetails.text = chapter.chapterNumber       //Small text
        cell.labelChapterNumber.text = chapter.chapterName        //Big Text
        switch chapter.status {
        case "0": //Not Startted
            cell.imageViewStatus.image = UIImage(named: Constants.Images.syllabusNotStarted)
            break
        case "1": //Inprogress
            cell.imageViewStatus.image = UIImage(named: Constants.Images.syllabusInProgress)
            break
        case "2"://completed
            cell.imageViewStatus.image = UIImage(named: Constants.Images.syllabusCompleted)
            break
        default:
            cell.imageViewStatus.image =  UIImage(named: Constants.Images.syllabusNotStarted)
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == ((self.arrayDataSource[indexPath.section].topicArray?.count)! - 1)){
            cell.makeEdgesRoundedWith(radius: 3.0)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableSyllabusDetails.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableSyllabusDetails.width(), height: 45.0))
        headerView.backgroundColor = UIColor.white
        headerView.makeEdgesRoundedWith(radius: 3.0)
        
        let label:UILabel = UILabel(frame: CGRect(x: 15, y: 0.0, width: headerView.width(), height: 15))
        label.center.y = headerView.centerY()
        label.text = self.arrayDataSource[section].unitName
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        headerView.addSubview(label)
        
        return headerView
    }

}
