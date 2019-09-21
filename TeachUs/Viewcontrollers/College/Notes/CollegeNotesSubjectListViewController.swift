//
//  CollegeNotesSubjectListViewController.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class CollegeNotesSubjectListViewController: BaseViewController {
    var selectedClass:ClassSubject!
    var classNotesCountObject:CollegeNotesClassSuject?
    @IBOutlet weak var tableViewLecturerNotesCount:UITableView!
    let nibCell = "CollegeSubjectAndProfessorNotesTableViewCell"
    var selectedProfessorSubject:ClassProfessorNotes!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.getCourseNotes()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableViewLecturerNotesCount.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notesProfesorListCellId)
        self.tableViewLecturerNotesCount.delegate = self
        self.tableViewLecturerNotesCount.dataSource = self
        self.tableViewLecturerNotesCount.estimatedRowHeight = 20
        self.tableViewLecturerNotesCount.rowHeight = UITableViewAutomaticDimension
        self.title = self.selectedClass.classSubjectClass
    }
    
    func getCourseNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeNotesProfessorList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.selectedClass.classID ?? "")"
        ]
        manager.apiPostWithDataResponse(apiName: "Get Student Notes List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.classNotesCountObject = try decoder.decode(CollegeNotesClassSuject.self, from: response)
                self.classNotesCountObject!.classSubjetcs!.sort(by: {$0.professorName! < $1.professorName! })
                DispatchQueue.main.async {
                    self.tableViewLecturerNotesCount.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toCollegeNotesDetals{
            let destinationVC:CollegeNotesSubjectDetialsViewController = segue.destination as! CollegeNotesSubjectDetialsViewController
            destinationVC.selectedProfessorObject = self.selectedProfessorSubject
            destinationVC.selectedClass = self.selectedClass
        }
    }

}

extension CollegeNotesSubjectListViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.classNotesCountObject?.classSubjetcs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CollegeSubjectAndProfessorNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notesProfesorListCellId) as! CollegeSubjectAndProfessorNotesTableViewCell
        
        if let subjectObject = self.classNotesCountObject?.classSubjetcs?[indexPath.section]{
            if let profileURL = subjectObject.profile, !profileURL.isEmpty{
                let imageURL = URLConstants.BaseUrl.baseURL + "/\(profileURL)"
                cell.imageVIewProfessor.imageFromServerURL(urlString: imageURL, defaultImage: Constants.Images.defaultProfessor)
            }else{
                if let image = UIImage(named: Constants.Images.defaultProfessor) {
                    cell.imageVIewProfessor.image = image
                }
            }
            cell.labelSubjectName.text = subjectObject.subjectName ?? ""
            cell.labelNotesCount.text = subjectObject.totalNotes ?? ""
            cell.labelLecturerName.text = subjectObject.professorName ?? ""
            if Int(subjectObject.totalNotes ?? "0") == 0{
                cell.isUserInteractionEnabled = false
                cell.imageViewRightArrow.isHidden = true
            }else{
                cell.isUserInteractionEnabled = true
                cell.imageViewRightArrow.isHidden = false
            }
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewLecturerNotesCount.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedProfessorSubject = self.classNotesCountObject?.classSubjetcs?[indexPath.section]
        self.performSegue(withIdentifier: Constants.segues.toCollegeNotesDetals, sender: self)
    }
}
