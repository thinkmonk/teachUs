//
//  CollegeNotesClassListViewController.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class CollegeNotesClassListViewController: BaseViewController {
    @IBOutlet weak var tableviewClassNotesList:UITableView!
    var parentNavigationController : UINavigationController?

    let nibCell = "CollegeSyllabusTableViewCell"
    var notesClassList:NotesClass!
    var selectedClass:ClassSubject!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableviewClassNotesList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.CollegeSyllabusTableViewCellId)
        self.tableviewClassNotesList.delegate = self
        self.tableviewClassNotesList.dataSource = self
        self.tableviewClassNotesList.estimatedRowHeight = 20
        self.tableviewClassNotesList.rowHeight = UITableViewAutomaticDimension
        self.getNotes()

        // Do any additional setup after loading the view.
    }
    
    func getNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeGetNotesClassList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
        ]
        manager.apiPostWithDataResponse(apiName: "Get Student Notes List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.notesClassList = try decoder.decode(NotesClass.self, from: response)
                DispatchQueue.main.async {
                    self.tableviewClassNotesList.reloadData()
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
        if segue.identifier == Constants.segues.toCollegeSubjectNotesList{
            let destinationVC: CollegeNotesSubjectListViewController = segue.destination as! CollegeNotesSubjectListViewController
            destinationVC.selectedClass = self.selectedClass
        }
    }

}

extension CollegeNotesClassListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notesClassList?.classSubjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CollegeSyllabusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.CollegeSyllabusTableViewCellId) as! CollegeSyllabusTableViewCell
        if let notesObject = self.notesClassList?.classSubjects?[indexPath.section]{
            cell.labelSyllabusSubject.text = notesObject.classSubjectClass ?? ""
            cell.labelSyllabusPercent.text =  notesObject.totalSubject ?? ""
            
            if Int(notesObject.totalSubject ?? "0") == 0{
                cell.imageViewRightArrow.isHidden = true
                cell.isUserInteractionEnabled = false
            }else{
                cell.imageViewRightArrow.isHidden = false
                cell.isUserInteractionEnabled = true
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewClassNotesList.width(), height: 15))
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
         self.selectedClass = self.notesClassList.classSubjects?[indexPath.section]
        self.performSegue(withIdentifier: Constants.segues.toCollegeSubjectNotesList, sender: self)
    }
    
}




extension CollegeNotesClassListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notes")
    }
}
