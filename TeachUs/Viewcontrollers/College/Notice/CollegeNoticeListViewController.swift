//
//  NoticeListViewController.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class CollegeNoticeListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    
    @IBOutlet weak var buttonAddNotice: UIButton!
    @IBOutlet weak var tableviewNoticeList: UITableView!
    @IBOutlet weak var layoutAddbuttonHeight: NSLayoutConstraint!
    var notesList:CollegeNoticeList?
    var selectedNotice:Notice?
    var nibCell = "CollegeNoticeListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableviewNoticeList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.collegeNoticeListCell)
        self.tableviewNoticeList.addSubview(refreshControl)
        self.tableviewNoticeList.delegate = self
        self.tableviewNoticeList.dataSource = self
        self.tableviewNoticeList.estimatedRowHeight  = 40
        self.tableviewNoticeList.rowHeight = UITableViewAutomaticDimension
        switch  UserManager.sharedUserManager.user!{
        case .college:
            self.buttonAddNotice.isHidden = false
            self.layoutAddbuttonHeight.constant = 40
        case .professor,.student:
            self.buttonAddNotice.isHidden = true
            self.layoutAddbuttonHeight.constant = 0
        default:
            self.buttonAddNotice.isHidden = true
            self.layoutAddbuttonHeight.constant = 0

        }
        self.getNoticeList()
    }
    
    override func refresh(sender: AnyObject) {
        self.getNoticeList()
        super.refresh(sender: self)
    }
    
    func getNoticeList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]

        switch  UserManager.sharedUserManager.user!{
        case .college:
            manager.url = URLConstants.CollegeURL.collegeNoticeList
        case .professor:
            manager.url = URLConstants.ProfessorURL.getNotice
        case .student:
            manager.url = URLConstants.StudentURL.getStudentNotice
        case .parents:
            manager.url = URLConstants.ParentsURL.getParentsNotice
            parameters["email"] = UserManager.sharedUserManager.appUserCollegeDetails.studentEmail ?? ""
        }

        manager.apiPostWithDataResponse(apiName: "Get Notice List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.notesList = try decoder.decode(CollegeNoticeList.self, from: response)
                DispatchQueue.main.async {
                    self.tableviewNoticeList.reloadData()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    @objc func downloadNotices(_ sender:ButtonWithIndexPath){

        if let noticeObejct = self.notesList?.notices?[sender.indexPath.section], let fileUrl = noticeObejct.filePath{
            let imageURL = "\(fileUrl)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:noticeObejct.generatedFileName ?? ""){
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.documentsVC) as! DocumentsViewController
                viewController.filepath = filePath
                viewController.fileURL = imageURL
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{// save file
                if let window = UIApplication.shared.keyWindow{
                    LoadingActivityHUD.showProgressHUD(view: window)
                }
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL, customName: noticeObejct.generatedFileName ?? "TeachUs\(Date())") { (success) in
                    LoadingActivityHUD.hideProgressHUD()
                    DispatchQueue.main.async {
                        self.tableviewNoticeList.reloadRows(at: [sender.indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    @objc func deleteNotices(_ sender:ButtonWithIndexPath){

        
        if let indexpath = sender.indexPath, let notice = self.notesList?.notices?[indexpath.section]
        {
            if notice.deleteFlag == .otherUser{
                let alert = UIAlertController(title: nil, message: "Only the notice creator can delete this notice", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion:nil)

            }else{
                let alert = UIAlertController(title: nil, message: "Are you sure, you want to delete this notice?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.deleteNoticeApiCall(noticeObj: notice)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
    
    private func deleteNoticeApiCall(noticeObj:Notice){
        if let noticeId =  noticeObj.noticeID
        {
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            let manager = NetworkHandler()
            manager.url = URLConstants.CollegeURL.deleteNotice
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "notice_id":"\(noticeId)"
            ]
            manager.apiPostWithDataResponse(apiName: "Delete Notice \(noticeObj.title ?? "")", parameters:parameters, completionHandler: { (result, code, response) in
                LoadingActivityHUD.hideProgressHUD()
                self.getNoticeList()
            }) { (error, code, message) in
                print(message)
                LoadingActivityHUD.hideProgressHUD()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toNoticeDetails{
            if let destinationVC = segue.destination as? CollegeNoticeDetailsViewController{
                destinationVC.delegate = self
                destinationVC.selectedNotice = self.selectedNotice
            }
        }
        
        if segue.identifier == Constants.segues.toAddNewNotice{
            if let destinationVC = segue.destination as? AddNewNoticeViewController{
                destinationVC.delegate = self
            }

        }
    }
    
    @IBAction func actionAddNotice(_ sender: Any) {
        
    }
}

extension CollegeNoticeListViewController:AddNewNoticeDelegate, NoticeDetailsDelegate{
    func viewDismissed(isNoticeAdded: Bool?) {
        if let noticeAddedFlag = isNoticeAdded, noticeAddedFlag == true{
            self.getNoticeList()
        }
    }
    
    func noticeDeleted() {
        self.getNoticeList()
    }
}

extension CollegeNoticeListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notesList?.notices?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.collegeNoticeListCell) as! CollegeNoticeListTableViewCell
        if let noticeObject = self.notesList?.notices?[indexPath.section]{
            cell.setUpNotice(noticeObject: noticeObject)
            cell.buttonDownload.indexPath = indexPath
            cell.buttonDeleteNotice.indexPath = indexPath
            cell.buttonDownload.addTarget(self, action: #selector(CollegeNoticeListViewController.downloadNotices(_:)), for: .touchUpInside)
            
            cell.buttonDeleteNotice.addTarget(self, action: #selector(CollegeNoticeListViewController.deleteNotices(_:)), for: .touchUpInside)

        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewNoticeList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let noticeObject = self.notesList?.notices?[indexPath.section]{
            self.selectedNotice = noticeObject
            self.performSegue(withIdentifier: Constants.segues.toNoticeDetails, sender: self)
        }
    }
    
}


extension CollegeNoticeListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notice")
    }
}
