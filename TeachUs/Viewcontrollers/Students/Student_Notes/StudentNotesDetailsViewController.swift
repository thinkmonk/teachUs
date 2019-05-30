//
//  StudentNotesDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class StudentNotesDetailsViewController: BaseViewController {
    @IBOutlet weak var tableViewStudentNotes: UITableView!
    var noteListData : NotesSubjectDetails?
    let nibCollegeListCell = "notesDetailsTableViewCell"
    var selectedNotesSubject:StudentSubjectList!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.getNotes()
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableViewStudentNotes.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notesDetailsCellId)
        self.tableViewStudentNotes.delegate = self
        self.tableViewStudentNotes.dataSource = self
        self.tableViewStudentNotes.estimatedRowHeight = 20
        self.tableViewStudentNotes.rowHeight = UITableViewAutomaticDimension

    }

    func getNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.getStudentNotesDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "subject_id" :self.selectedNotesSubject.subjectID ?? "",
        ]
        manager.apiPostWithDataResponse(apiName: "Get Notes Details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.noteListData = try decoder.decode(NotesSubjectDetails.self, from: response)
                DispatchQueue.main.async {
                    self.tableViewStudentNotes.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }

}
extension StudentNotesDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.noteListData?.notesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:notesDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notesDetailsCellId) as! notesDetailsTableViewCell
        if let notes = self.noteListData?.notesList?[indexPath.section]{
            cell.setUpNotes(notesData: notes)
            cell.buttonDownloadNotes.addTarget(self, action: #selector(ProfessorNotesDetailstViewController.downloadNotes(_:)), for: .touchUpInside)
            cell.buttonDeleteNotes.addTarget(self, action: #selector(ProfessorNotesDetailstViewController.deleteNote(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.buttonDeleteNotes.isHidden = true
            cell.buttonDeleteNotes.setWidth(0)
            cell.buttonDeleteNotes.indexPath = indexPath
            cell.buttonDownloadNotes.indexPath = indexPath
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewStudentNotes.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
        
    }
    
}
