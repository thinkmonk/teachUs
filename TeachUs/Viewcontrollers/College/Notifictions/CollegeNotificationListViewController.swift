//
//  CollegeNotificationListViewController.swift
//  TeachUs
//
//  Created by ios on 6/3/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class CollegeNotificationListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    var notificationObject:CollegeNotificationList?
    @IBOutlet weak var tableviewNotificationList:UITableView!
    var nibCell = "NotificationListTableViewCell"
    var selectedNotification :NotificationList!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableviewNotificationList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notificationCellId)
        self.tableviewNotificationList.delegate = self
        self.tableviewNotificationList.dataSource = self
        self.tableviewNotificationList.estimatedRowHeight = 40
        self.tableviewNotificationList.rowHeight = UITableViewAutomaticDimension
        self.getNotificationList()
        // Do any additional setup after loading the view.
    }
    
    
    func getNotificationList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        switch  UserManager.sharedUserManager.user!{
        case .College:
            manager.url = URLConstants.CollegeURL.getcollegeNotificationList
        case .Professor:
            manager.url = URLConstants.ProfessorURL.getNotificationList
        case .Student:
            manager.url = URLConstants.StudentURL.getNotificationList
        }
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
        ]
        manager.apiPostWithDataResponse(apiName: "Get Notice List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.notificationObject = try decoder.decode(CollegeNotificationList.self, from: response)
                DispatchQueue.main.async {
                    self.tableviewNotificationList.reloadData()
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
        if segue.identifier == Constants.segues.toNotificationDetails{
            if let destinationVC = segue.destination as? CollegeNotificationDetailsViewController{
                destinationVC.selectedNotification = self.selectedNotification
            }
        }
    }

}


extension CollegeNotificationListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notificationObject?.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notificationCellId) as! NotificationListTableViewCell
        cell.selectionStyle = .none
        if let notification = self.notificationObject?.notifications?[indexPath.section]{
            cell.setUpCell(notificationObj: notification)
            cell.imageViewrightArrow.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewNotificationList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let notificaiton = self.notificationObject?.notifications?[indexPath.section]{
            self.selectedNotification = notificaiton
            self.performSegue(withIdentifier: Constants.segues.toNotificationDetails, sender: self)
        }
    }
}


extension CollegeNotificationListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notification")
    }
}

