//
//  BellNotificationListViewController.swift
//  TeachUs
//
//  Created by ios on 6/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class BellNotificationListViewController: BaseViewController {
    @IBOutlet weak var tableviewBellNotificationList: UITableView!
    @IBOutlet weak var labelNoNotification: UILabel!
    let cellId = "BellNotificationListTableViewCell"
    var arrayNotifications : BellNotificationList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        let cellNib = UINib(nibName:cellId, bundle: nil)
        self.tableviewBellNotificationList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.bellNotificationCellId)
        self.tableviewBellNotificationList.delegate = self
        self.tableviewBellNotificationList.dataSource = self
        self.tableviewBellNotificationList.estimatedRowHeight = 70
        self.tableviewBellNotificationList.rowHeight = UITableViewAutomaticDimension
        self.getNotificationList()
        self.labelNoNotification.isHidden = true
    }
    
    func getNotificationList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        switch  UserManager.sharedUserManager.user!{
        case .College:
            manager.url = URLConstants.CollegeURL.getBellNotifications
        case .Professor:
            manager.url = URLConstants.ProfessorURL.getBellNotifications
        case .Student:
            manager.url = URLConstants.StudentURL.getBellNotifications
        }
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
        ]
        manager.apiPostWithDataResponse(apiName: "Get Notice List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.arrayNotifications = try decoder.decode(BellNotificationList.self, from: response)
                if((self.arrayNotifications?.notifications?.count ?? 0) > 0){
                    DispatchQueue.main.async {
                        self.labelNoNotification.isHidden = true
                        self.tableviewBellNotificationList.reloadData()
                    }
                }else{
                    self.labelNoNotification.isHidden = false
                    self.tableviewBellNotificationList.isHidden = false
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


extension BellNotificationListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayNotifications?.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BellNotificationListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.bellNotificationCellId, for: indexPath) as! BellNotificationListTableViewCell
        
        if let bellNotificationObj = self.arrayNotifications?.notifications?[indexPath.section]{
            cell.labelNotificationDescription.text = "\(bellNotificationObj.data?.message ?? "NA")"
            cell.labelNotificaitondate.text = "\(bellNotificationObj.created ?? "")"
        }
        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewBellNotificationList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
