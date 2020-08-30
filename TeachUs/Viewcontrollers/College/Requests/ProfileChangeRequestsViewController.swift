//
//  ProfileChangeRequestsViewController.swift
//  TeachUs
//
//  Created by ios on 5/26/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ProfileChangeRequestsViewController: BaseViewController {

    @IBOutlet weak var tableViewRequestLIst: UITableView!
    var changeRequestObject:ChangeRequest!
    var parentNavigationController : UINavigationController?
    var selectedDetailsObject:RequestData!
    var viewRequestDetails:ViewProfileRequestDetails!
    var arrayDataSource = [ChangeRequestsDataSource]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewRequestLIst.register(UINib(nibName: "ProfileChangeRequestTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.profileChangeRequestTableViewCellId)
        self.tableViewRequestLIst.delegate = self
        self.tableViewRequestLIst.dataSource = self
        self.tableViewRequestLIst.estimatedRowHeight = 35
        self.tableViewRequestLIst.rowHeight = UITableViewAutomaticDimension
        self.tableViewRequestLIst.contentInset.top = 20
        self.tableViewRequestLIst.addSubview(refreshControl)
        self.getRequestChangeData()

    }
    
    override func refresh(sender: AnyObject) {
        self.getRequestChangeData()
        super.refresh(sender: sender)
    }
    
    func getRequestChangeData(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getProfileChangeRequests
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get Profile changes requests", parameters: parameters, completionHandler: { [weak self] (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self`  = self else { return }
            do{
                let decoder = JSONDecoder()
                self.changeRequestObject = try decoder.decode(ChangeRequest.self, from: response)
                self.makeDataSource()
            }catch let error {
                print("parsing error \(error)")
            }
        }) { (success, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlertWithTitle("Error", alertMessage: errorMessage)
        }
    }
    
    func setupUpDetailView(){
        if self.viewRequestDetails == nil{
            self.viewRequestDetails =  ViewProfileRequestDetails.instanceFromNib() as? ViewProfileRequestDetails
            self.viewRequestDetails.delegate = self
        }
        self.viewRequestDetails.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width(), height: self.view.height())
        self.viewRequestDetails.setUpRequestData(data: self.selectedDetailsObject)
        if !self.view.subviews.contains(self.viewRequestDetails){
            self.view.addSubview(self.viewRequestDetails)
        }
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        //name change requests
        for nameReq in changeRequestObject.requestData ?? []{
            let ds = ChangeRequestsDataSource(celType: .nameChange, attachedObject: nameReq)
            arrayDataSource.append(ds)
        }
        
        for log in changeRequestObject.logArray ?? []{
            let ds = ChangeRequestsDataSource(celType: .deleteAttendance, attachedObject: log)
            arrayDataSource.append(ds)
        }
        
        
        self.tableViewRequestLIst.reloadData()
    }
    
    func updateRequestData(_ isApproved:Bool){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.updateRequestDetails
        var parameters = [String:Any]()
        parameters["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code ?? "")"
        parameters["request_id"]  = Int(self.selectedDetailsObject?.verifyDocumentsId ?? "0")
        parameters["status"] = isApproved ? 1 : 2
        manager.apiPost(apiName: "Update profile change request", parameters: parameters, completionHandler: { (result, code, reponse) in
            LoadingActivityHUD.hideProgressHUD()
            if code == 200{
                self.viewRequestDetails.removeFromSuperview()
                self.getRequestChangeData()
            }
        }) { (result, code, errorString) in
            LoadingActivityHUD.hideProgressHUD()
            self.viewRequestDetails.removeFromSuperview()
            self.getRequestChangeData()
        }
    }
    
    func showDeleteAttendanceView(for logObject:LogArray){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC:AttendanceDeleteRequestViewController =  storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.attendanceDeleteRequest) as! AttendanceDeleteRequestViewController
        destinationVC.logDetails = logObject
        destinationVC.delegate = self
        self.present(destinationVC, animated: true, completion: nil)

    }
    
}

extension ProfileChangeRequestsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let dataSource = arrayDataSource[indexPath.section]
        
        switch  dataSource.cellType{
        case .nameChange:
            let requestObject = dataSource.attachedObject as? RequestData
            let cell:ProfileChangeRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileChangeRequestTableViewCellId) as! ProfileChangeRequestTableViewCell
            cell.setUpCell(data:requestObject!)
            
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell

        case .deleteAttendance:
            let requestObject = dataSource.attachedObject as? LogArray
            let cell:ProfileChangeRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileChangeRequestTableViewCellId) as! ProfileChangeRequestTableViewCell
            cell.setUpCell(data:requestObject!)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell

        case .none:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 15))
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
        let dataSource = arrayDataSource[indexPath.section]
        switch dataSource.cellType {
        case .nameChange:
            if let data = dataSource.attachedObject as? RequestData{
                
                self.selectedDetailsObject = data
                self.setupUpDetailView()
            }
            
        case .deleteAttendance:
            if let logObj = dataSource.attachedObject as? LogArray{
                self.showDeleteAttendanceView(for: logObj)
            }
            break
            
        case .none:  break
        }
    }
}


extension ProfileChangeRequestsViewController:ViewProfileRequestDetailsDelegate{
    func downloadProof() {
        if let fileUrl = self.selectedDetailsObject.filePath{
            let imageURL = URLConstants.BaseUrl.baseURL + "/\(fileUrl)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL){
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.documentsVC) as! DocumentsViewController
                viewController.filepath = filePath
                viewController.fileURL = imageURL
                self.navigationController?.pushViewController(viewController, animated: true)

            }else{// save file
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL)
            }
            
        }
    }
    
    func approve() {
        self.updateRequestData(true)
    }
    
    func reject() {
        self.updateRequestData(false)
    }
    
    func close() {
        self.viewRequestDetails.removeFromSuperview()
    }
    
    
}

extension ProfileChangeRequestsViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Request")
    }
}

extension ProfileChangeRequestsViewController:DeleteRequestDelegate{
    func requestUpdated() {
        self.getRequestChangeData()
    }
}
