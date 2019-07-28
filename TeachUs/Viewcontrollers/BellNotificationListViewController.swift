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
        self.tableviewBellNotificationList.addSubview(refreshControl)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.Images.checkMarkReadAll), style: .plain, target: self, action: #selector(BellNotificationListViewController.markAllRead))
    }
    
    override func refresh(sender: AnyObject) {
        self.getNotificationList()
        super.refresh(sender: sender)
    }
    
    @objc func markAllRead(){
        let alert = UIAlertController(title: nil, message: "Are you sure you want to mark all unread notifications as read?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { _ in
            //send comma seperated values of all the unread notifications.
            let allNotifictionId = self.arrayNotifications?.notifications?.filter({$0.notificationRead?.elementsEqual("0") ?? false}).map({$0.id ?? ""}).joined(separator: ",") ?? ""
            if !allNotifictionId.isEmpty
            {
                self.markReadNotification(firebaseID: allNotifictionId)
                for i in 0..<(self.arrayNotifications?.notifications?.count ?? 0){
                    self.arrayNotifications?.notifications?[i].notificationRead = "1"
                }
                DispatchQueue.main.async {
                    self.tableviewBellNotificationList.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion:nil)

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
    
    func markReadNotification(firebaseID:String){
        let manager = NetworkHandler()
        switch  UserManager.sharedUserManager.user!{
        case .College:
            manager.url = URLConstants.CollegeURL.markReadNotification
        case .Professor:
            manager.url = URLConstants.ProfessorURL.markReadNotification
        case .Student:
            manager.url = URLConstants.StudentURL.markReadNotification
        }
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "firebaseid":firebaseID
        ]
        
        manager.apiPostWithDataResponse(apiName: "Mark notification read", parameters:parameters, completionHandler: { (result, code, response) in
            
            do{
                let decoder = JSONDecoder()
                let readStatus = try decoder.decode(BellNotificationReadStatus.self, from: response)
                UserManager.sharedUserManager.appUserCollegeDetails.notificationCount = readStatus.totalNotification
                NotificationCenter.default.post(name: .notificationBellCountUpdate, object: nil)

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
        
        if let bellNotificationObj = self.arrayNotifications?.notifications?[indexPath.section], let isRead = bellNotificationObj.notificationRead?.elementsEqual("1"){
            cell.labelNotificationDescription.text = "\(bellNotificationObj.data?.message ?? "NA")"
            cell.labelNotificaitondate.text = "\(bellNotificationObj.created ?? "")"
            cell.viewReadDot.isHidden = isRead
            if isRead{
                cell.labelNotificationDescription.font = UIFont.systemFont(ofSize: 17.0)
                cell.labelNotificationDescription.textColor = .lightGray
                cell.labelNotificaitondate.textColor = .lightGray
            }else{
                cell.labelNotificationDescription.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                cell.labelNotificationDescription.textColor = .black
                cell.labelNotificaitondate.textColor = .black

                
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bellNotificationObj = self.arrayNotifications?.notifications?[indexPath.section]{
            if let status = Int(bellNotificationObj.notificationRead ?? "") ,let notificationId = bellNotificationObj.id{
                if !status.boolValue{//make api call only for unread notifications
                    self.arrayNotifications?.notifications?[indexPath.section].notificationRead = "1"
                    self.markReadNotification(firebaseID: notificationId)
                    self.tableviewBellNotificationList.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}
