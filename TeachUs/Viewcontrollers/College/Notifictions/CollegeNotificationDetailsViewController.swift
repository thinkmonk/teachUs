//
//  CollegeNotificationDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 6/3/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class CollegeNotificationDetailsViewController: BaseViewController {

    var selectedNotification : NotificationList?
    @IBOutlet weak var tableviewNotificationDetails:UITableView!
    var nibCell = "NotificationListTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        let cellNib = UINib(nibName:nibCell, bundle: nil)
        self.tableviewNotificationDetails.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.notificationCellId)
        self.tableviewNotificationDetails.delegate = self
        self.tableviewNotificationDetails.dataSource = self
        self.tableviewNotificationDetails.estimatedRowHeight = 40
        self.tableviewNotificationDetails.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
}

extension CollegeNotificationDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.notificationCellId) as! NotificationListTableViewCell
        cell.selectionStyle = .none
        if let notification = self.selectedNotification{
            cell.setUpCell(notificationObj: notification)
            cell.labelNotificationTitle.numberOfLines = 0
            cell.labelNotificationDescription.numberOfLines = 0
            cell.imageViewrightArrow.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableviewNotificationDetails.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
