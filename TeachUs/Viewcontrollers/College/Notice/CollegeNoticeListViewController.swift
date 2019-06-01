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
    var notesList:CollegeNoticeList?
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
        self.getNoticeList()
    }
    
    override func refresh(sender: AnyObject) {
        self.getNoticeList()
        super.refresh(sender: self)
    }
    
    func getNoticeList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeNoticeList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
        ]
        manager.apiPostWithDataResponse(apiName: "Get Student Notes List", parameters:parameters, completionHandler: { (result, code, response) in
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
        let cellView = tableviewNoticeList.cellForRow(at: sender.indexPath) as! CollegeNoticeListTableViewCell

        if let noticeObejct = self.notesList?.notices?[sender.indexPath.section], let fileUrl = noticeObejct.filePath{
            let imageURL = "\(fileUrl)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:noticeObejct.generatedFileName ?? ""){
                let webView = UIWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height))
                webView.loadRequest(URLRequest(url: URL(fileURLWithPath: filePath)))
                let pdfVC = BaseViewController() //create a view controller for view only purpose
                pdfVC.view.addSubview(webView)
                webView.scalesPageToFit = true
                pdfVC.title = "\(URL(string: fileUrl)?.lastPathComponent ?? "")"
                self.navigationController?.pushViewController(pdfVC, animated: true)
                pdfVC.addGradientToNavBar()
            }else{// save file
                LoadingActivityHUD.showProgressHUD(view: cellView.viewWrapper)
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL, customName: noticeObejct.generatedFileName ?? "TeachUs\(Date())") { (success) in
                    LoadingActivityHUD.hideProgressHUD()
                    DispatchQueue.main.async {
                        self.tableviewNoticeList.reloadRows(at: [sender.indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func actionAddNotice(_ sender: Any) {
        
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
            cell.buttonDownload.addTarget(self, action: #selector(CollegeNoticeListViewController.downloadNotices(_:)), for: .touchUpInside)
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
    
}


extension CollegeNoticeListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notice")
    }
}
