//
//  StudentNotesListViewController.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class StudentNotesListViewController: UIViewController {
    var parentNavigationController : UINavigationController?
    let nibCell = "CollegeSyllabusTableViewCell"
    var studentNotesList:StudentNotesSubjectList?
    var selectedNotesObject : StudentSubjectList?

    @IBOutlet weak var tableViewNotesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableViewNotesList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.CollegeSyllabusTableViewCellId)
        self.tableViewNotesList.delegate = self
        self.tableViewNotesList.dataSource = self
        self.tableViewNotesList.estimatedRowHeight = 20
        self.tableViewNotesList.rowHeight = UITableViewAutomaticDimension
        self.getNotes()
        // Do any additional setup after loading the view.
    }
    
    
    func getNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.getStudentNotesList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
        ]
        manager.apiPostWithDataResponse(apiName: "Get Student Notes List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.studentNotesList = try decoder.decode(StudentNotesSubjectList.self, from: response)
                DispatchQueue.main.async {
                    self.tableViewNotesList.reloadData()
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
        if  segue.identifier == Constants.segues.toStudentNotesDetails{
            let destinationVc : StudentNotesDetailsViewController = segue.destination as! StudentNotesDetailsViewController
                destinationVc.selectedNotesSubject = self.selectedNotesObject
            
        }
    }
    
}


extension StudentNotesListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.studentNotesList?.subjectList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CollegeSyllabusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.CollegeSyllabusTableViewCellId) as! CollegeSyllabusTableViewCell
        if let notesObject = self.studentNotesList?.subjectList?[indexPath.section]{
            cell.labelSyllabusSubject.text = notesObject.subjectName
            cell.labelSyllabusPercent.text = "\(notesObject.totalNotes ?? 0)"
            
            if (notesObject.totalNotes ?? 0) == 0 {
                cell.isUserInteractionEnabled = false
                cell.imageViewRightArrow.isHidden = true
            }else{
                cell.isUserInteractionEnabled = true
                cell.imageViewRightArrow.isHidden = false

            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewNotesList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedNotesObject = self.studentNotesList?.subjectList?[indexPath.section]
        self.performSegue(withIdentifier: Constants.segues.toStudentNotesDetails, sender: self)
    }
    
}


extension StudentNotesListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notes")
    }
}
