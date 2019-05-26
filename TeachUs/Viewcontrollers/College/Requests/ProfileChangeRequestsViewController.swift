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


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewRequestLIst.register(UINib(nibName: "ProfileChangeRequestTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.profileChangeRequestTableViewCellId)
        self.tableViewRequestLIst.delegate = self
        self.tableViewRequestLIst.dataSource = self
        self.tableViewRequestLIst.estimatedRowHeight = 35
        self.tableViewRequestLIst.rowHeight = UITableViewAutomaticDimension
        self.tableViewRequestLIst.contentInset = UIEdgeInsetsMake(20, 0, 0, 20)
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
        
        manager.apiPostWithDataResponse(apiName: "Get Profile chnages requests", parameters: parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.changeRequestObject = try decoder.decode(ChangeRequest.self, from: response)
                self.tableViewRequestLIst.reloadData()
            }catch let error {
                print("parsing error \(error)")
            }
        }) { (success, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            self.showAlterWithTitle("Error", alertMessage: errorMessage)
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
    
    func updateRequestData(_ isApproved:Bool){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.updateRequestDetails
        var parameters = [String:Any]()
        parameters["college_code"] = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code ?? "")"
        parameters["request_id"]  = Int(self.selectedDetailsObject?.verifyDocumentsID ?? "0")
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
    
}

extension ProfileChangeRequestsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.changeRequestObject?.requestData?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestObject = self.changeRequestObject?.requestData![indexPath.row]
        let cell:ProfileChangeRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileChangeRequestTableViewCellId) as! ProfileChangeRequestTableViewCell
        cell.setUpCell(data:requestObject!)
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewRequestLIst.width(), height: 15))
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
        self.selectedDetailsObject = self.changeRequestObject?.requestData![indexPath.section]
        self.setupUpDetailView()
    }
}

extension ProfileChangeRequestsViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Request")
    }
}

extension ProfileChangeRequestsViewController:ViewProfileRequestDetailsDelegate{
    func downloadProof() {
        if let fileUrl = self.selectedDetailsObject.filePath{
            let imageURL = URLConstants.BaseUrl.baseURL + "/\(fileUrl)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL){
                let webView = UIWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height))
                webView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath)))
                let pdfVC = BaseViewController() //create a view controller for view only purpose
                pdfVC.view.addSubview(webView)
                pdfVC.title = "\(URL(string: fileUrl)?.lastPathComponent ?? "")"
                self.navigationController?.pushViewController(pdfVC, animated: true)
                pdfVC.addGradientToNavBar()
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
