//
//  EventAttendanceListViewController.swift
//  TeachUs
//
//  Created by ios on 4/7/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper


class EventAttendanceListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    @IBOutlet weak var tableViewEvents: UITableView!
    var arrayDataSource:[Event] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewEvents.register(UINib(nibName: "EventListTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.EventListTableViewCellId)
        self.getEvents()
        self.tableViewEvents.alpha = 0
        self.tableViewEvents.delegate = self
        self.tableViewEvents.dataSource = self
        self.tableViewEvents.estimatedRowHeight = 90
        self.tableViewEvents.rowHeight = UITableViewAutomaticDimension
        self.tableViewEvents.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refresh(sender: AnyObject) {
        self.getEvents()
        super.refresh(sender: sender)
    }
    
    //MARK:- Outlet Methods
    
    @IBAction func addNewEvent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController:AddNewEventViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.AddNewEventViewControllerId) as! AddNewEventViewController
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Custom Methods

    func getEvents(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getEventlList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPost(apiName: " Get all events", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let evetArray = response["events_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for event in evetArray{
                let tempEvent = Mapper<Event>().map(JSONObject: event)
                self.arrayDataSource.append(tempEvent!)
                self.tableViewEvents.reloadData()
                self.showTableView()
            }
           
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableViewEvents.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewEvents.alpha = 1.0
            self.tableViewEvents.transform = CGAffineTransform.identity
        }
    }
}


extension EventAttendanceListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.EventListTableViewCellId, for: indexPath) as! EventListTableViewCell
        cell.labelEventName.text = "\(self.arrayDataSource[indexPath.section].eventName)"
        cell.labelStudentCount.text = "\(self.arrayDataSource[indexPath.section].totalParticipants) Students"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewEvents.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segues.toClassList, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toClassList {
            let destinationVC:EventAttendanceClassListViewController = segue.destination as! EventAttendanceClassListViewController
            let indexpath = self.tableViewEvents.indexPathForSelectedRow
            destinationVC.currentEvent = arrayDataSource[(indexpath?.section)!]
        }
    }
    
}


extension EventAttendanceListViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance (Events)")
    }
}
