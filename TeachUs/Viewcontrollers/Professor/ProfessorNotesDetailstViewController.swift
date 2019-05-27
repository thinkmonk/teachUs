//
//  ProfessorNotesDetailstViewController.swift
//  TeachUs
//
//  Created by ios on 5/28/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class ProfessorNotesDetailstViewController: UIViewController {

    @IBOutlet weak var tableViewNotesDetails: UITableView!
    var selectedNotesSubject:SubjectList!
    var noteList : NotesList!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNotes()

        // Do any additional setup after loading the view.
    }
    
    func getNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getNotesDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "subject_id" :self.selectedNotesSubject.subjectID ?? "",
            "class_id":self.selectedNotesSubject.classID ?? ""
        ]
        manager.apiPostWithDataResponse(apiName: "Get Notes Details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.noteList = try decoder.decode(NotesList.self, from: response)
                DispatchQueue.main.async {
                    self.tableViewNotesDetails.reloadData()
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
