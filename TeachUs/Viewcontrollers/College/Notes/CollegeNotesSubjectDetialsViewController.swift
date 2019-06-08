//
//  CollegeNotesSubjectDetialsViewController.swift
//  TeachUs
//
//  Created by ios on 5/31/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class CollegeNotesSubjectDetialsViewController: BaseViewController {
    var selectedClass:ClassSubject!
    var selectedProfessorObject:ClassProfessorNotes!
    @IBOutlet weak var tableViewNotes:UITableView!
    @IBOutlet weak var labelSubjectName: UILabel!
    
    let nibCollegeListCell = "notesDetailsTableViewCell"
    var noteListData : CollegeNotesDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        let cellNib = UINib(nibName:nibCollegeListCell, bundle: nil)
        self.tableViewNotes.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notesDetailsCellId)
        self.tableViewNotes.delegate = self
        self.tableViewNotes.dataSource = self
        self.tableViewNotes.estimatedRowHeight = 20
        self.tableViewNotes.rowHeight = UITableViewAutomaticDimension
        self.getNotes()
        self.labelSubjectName.text = self.selectedProfessorObject.subjectName ?? ""
    }
    
    func getNotes()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeNotesDetail
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "subject_id" :self.selectedProfessorObject.subjectID ?? "",
            "class_id":self.selectedClass.classID ?? "",
            "professor_id":self.selectedProfessorObject.professorID ?? ""
        ]
        manager.apiPostWithDataResponse(apiName: "Get Notes Details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.noteListData = try decoder.decode(CollegeNotesDetails.self, from: response)
                DispatchQueue.main.async {
                    self.tableViewNotes.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    @objc func downloadNotes(_ sender:ButtonWithIndexPath){
        
        
        if let notesObejct = self.noteListData?.classSubjects?[sender.indexPath.section], let fileUrl = notesObejct.filePath{
            let imageURL = "\(fileUrl)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:notesObejct.generatedFileName ?? ""){
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.documentsVC) as! DocumentsViewController
                viewController.filepath = filePath
                viewController.fileURL = imageURL
                self.navigationController?.pushViewController(viewController, animated: true)

                
                /*
                let webView = UIWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height))
                webView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath)))
                let pdfVC = BaseViewController() //create a view controller for view only purpose
                pdfVC.view.addSubview(webView)
                webView.scalesPageToFit = true
                pdfVC.title = "\(URL(string: fileUrl)?.lastPathComponent ?? "")"
                self.navigationController?.pushViewController(pdfVC, animated: true)
                pdfVC.addGradientToNavBar()
                */
            }else{// save file
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL, customName: notesObejct.generatedFileName ?? "TeachUs\(Date())") { (success) in
                    DispatchQueue.main.async {
                        self.tableViewNotes.reloadRows(at: [sender.indexPath], with: .fade)
                    }
                }
            }
            
        }
    }
        

}

extension CollegeNotesSubjectDetialsViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.noteListData?.classSubjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:notesDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notesDetailsCellId) as! notesDetailsTableViewCell
        if let notes = self.noteListData?.classSubjects?[indexPath.section]{
            cell.setUpNotes(notesData: notes)
            cell.buttonDownloadNotes.addTarget(self, action: #selector(CollegeNotesSubjectDetialsViewController.downloadNotes(_:)), for: .touchUpInside)
            cell.buttonDeleteNotes.isHidden = true
            cell.buttonDeleteNotes.setWidth(0)
            cell.selectionStyle = .none
            cell.buttonDeleteNotes.indexPath = indexPath
            cell.buttonDownloadNotes.indexPath = indexPath
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewNotes.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
        
    }
    
}
