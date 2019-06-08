//
//  CollegeNoticeDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 6/1/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class CollegeNoticeDetailsViewController: BaseViewController {
    var selectedNotice:Notice?
    @IBOutlet weak var tableviewNoticeDetails:UITableView!
    var nibCell = "CollegeNoticeListTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableviewNoticeDetails.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.collegeNoticeListCell)
        self.tableviewNoticeDetails.delegate = self
        self.tableviewNoticeDetails.dataSource = self
        self.tableviewNoticeDetails.estimatedRowHeight  = 40
        self.tableviewNoticeDetails.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    
    

    @objc func downloadNotices(_ sender:ButtonWithIndexPath){
        
        if let noticeObejct = self.selectedNotice, let fileUrl = noticeObejct.filePath{
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
                        self.tableviewNoticeDetails.reloadRows(at: [sender.indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    

}

extension CollegeNoticeDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.collegeNoticeListCell) as! CollegeNoticeListTableViewCell
        if let noticeObject = self.selectedNotice{
            cell.labelNoticeTitle.numberOfLines = 0
            cell.labelNoticeDescription.numberOfLines = 0
            cell.labelNoticeClassDetails.numberOfLines = 0
            cell.setUpNotice(noticeObject: noticeObject)
            cell.buttonDownload.indexPath = indexPath
            cell.buttonDownload.addTarget(self, action: #selector(CollegeNoticeListViewController.downloadNotices(_:)), for: .touchUpInside)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewNoticeDetails.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}
