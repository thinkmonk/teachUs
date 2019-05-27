//
//  ProfessorNotesSubjectListViewController.swift
//  TeachUs
//
//  Created by ios on 5/27/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ProfessorNotesSubjectListViewController: BaseViewController {
    var notesList:NotesSubjectList?
    var parentNavigationController : UINavigationController?
    let nibCollegeListCell = "SubjectNotesTableViewCell"
    var selectedSubject:SubjectList!

    @IBOutlet weak var tableViewNotesList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableViewNotesList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notesListCellId)
        self.tableViewNotesList.estimatedRowHeight = 20
        self.tableViewNotesList.rowHeight = UITableViewAutomaticDimension
        self.tableViewNotesList.delegate = self
        self.tableViewNotesList.dataSource = self
        self.tableViewNotesList.backgroundColor = .clear
        self.getSujectList()
    }
    
    func getSujectList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getNotesList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        manager.apiPostWithDataResponse(apiName: "Get student profile", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.notesList = try decoder.decode(NotesSubjectList.self, from: response)
                self.notesList?.subjectList?.sort(by: { $0.subjectListClass! < $1.subjectListClass! })
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
        if segue.identifier == Constants.segues.toNotesDetails{
            if let destinationVC = segue.destination as? ProfessorNotesDetailstViewController{
                destinationVC.selectedNotesSubject = self.selectedSubject
            }
        }
    }

}

extension ProfessorNotesSubjectListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notesList?.subjectList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SubjectNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notesListCellId, for: indexPath)  as! SubjectNotesTableViewCell
        if let notesObject = self.notesList?.subjectList?[indexPath.section]{
            cell.setUpData(notesOBject: notesObject)
        }
        cell.accessoryType = .disclosureIndicator
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
        if let notesObject = self.notesList?.subjectList?[indexPath.section]{
            self.selectedSubject = notesObject
        }
        self.performSegue(withIdentifier: Constants.segues.toNotesDetails, sender: self)
    }
}

extension ProfessorNotesSubjectListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notes")
    }
}
