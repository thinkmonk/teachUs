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
import RxSwift
import RxCocoa


class EventAttendanceListViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    @IBOutlet weak var tableViewEvents: UITableView!
    @IBOutlet weak var buttonAddEvent: UIButton!
    @IBOutlet weak var buttonAllClass: UIButton!
    @IBOutlet weak var buttonShowClassList: UIButton!
    @IBOutlet weak var textFieldEventName: UITextField!
    var arrayDataSource:[Event] = []
    var disposeBag = DisposeBag()
    var viewCourseList : ViewCourseSelection!
    var dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewEvents.register(UINib(nibName: "EventListTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.EventListTableViewCellId)
        self.tableViewEvents.alpha = 0
        self.tableViewEvents.delegate = self
        self.tableViewEvents.dataSource = self
        self.tableViewEvents.estimatedRowHeight = 90
        self.tableViewEvents.rowHeight = UITableViewAutomaticDimension
        self.tableViewEvents.addSubview(refreshControl)
        self.setUpRx()
        self.getEvents()
        self.getCourseList()
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.initCourseSelectionView()
            self.tableViewEvents.reloadData()
            self.showTableView()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getEventsAndReloadData), name: .eventDeleted, object: nil)
        
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
        let date = Date()
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultDateString = inputFormatter.string(from: date)
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "event_name":"\(self.textFieldEventName.text ?? "")",
            "event_code":"\(self.textFieldEventName.text ?? "")",
            "event_description":"\(self.textFieldEventName.text ?? "")",
            "event_date":"\(resultDateString)",
            "course_id":"\(CollegeClassManager.sharedManager.getSelectedCourseList)"
        ]
        
        EventManager.shared.addEvent(params: parameters) { (successFlag, message) in
            if successFlag{
                self.showAlertWithTitle(nil, alertMessage: message ?? "")
                self.textFieldEventName.text = ""
                self.getEvents()
                self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    self.tableViewEvents.reloadData()
                    self.view.endEditing(true)
                })
            }else{
                self.showAlertWithTitle(nil, alertMessage: message ?? "")
                LoadingActivityHUD.hideProgressHUD()
                
            }
        }
    }
    
    @IBAction func showCourseList(_ sender: Any) {
        self.view.endEditing(true)
        if self.viewCourseList != nil{
            self.viewCourseList.frame = CGRect(x: 0.0, y:0.0, width: self.view.width(), height: self.view.height())
            self.view.addSubview(self.viewCourseList)
        }
    }
    
    
    
    //MARK:- Custom Methods
    
    func initCourseSelectionView(){
        self.viewCourseList = ViewCourseSelection.instanceFromNib() as? ViewCourseSelection
        self.viewCourseList.delegate = self
        CollegeClassManager.sharedManager.selectedCourseArray.removeAll()

        //init class selection list after sorting
        if let listData = CollegeClassManager.sharedManager.courseListData{
            
            for course in listData.courseList
            {
                let selectedCourse = SelectCollegeCourse(course, true)
                CollegeClassManager.sharedManager.selectedCourseArray.append(selectedCourse)
            }
        }else{
            CollegeClassManager.sharedManager.getCourseList { (_) in
                if let listData = CollegeClassManager.sharedManager.courseListData{
                    for course in listData.courseList{
                        let selectedCourse = SelectCollegeCourse(course, true)
                        CollegeClassManager.sharedManager.selectedCourseArray.append(selectedCourse)
                    }
                }
            }
        }
    }
    
    
    @objc func getEventsAndReloadData(){
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
            }
            self.arrayDataSource.sort(by: { $0.eventName < $1.eventName })
            DispatchQueue.main.async {
                self.tableViewEvents.reloadData()
            }
        }) { (error, code, message) in
            self.showAlertWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }

    @objc func getEvents(){
        self.dispatchGroup.enter()
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
            }
            self.arrayDataSource.sort(by: { $0.eventName < $1.eventName })
           self.dispatchGroup.leave()
        }) { (error, code, message) in
            self.showAlertWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func getCourseList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.dispatchGroup.enter()
        CollegeClassManager.sharedManager.getCourseList { (isCompleted) in
            LoadingActivityHUD.hideProgressHUD()
            self.dispatchGroup.leave()
        }
    }
    
    func setUpRx(){
        let isEventNameValid: Observable<Bool> = self.textFieldEventName.rx.text
            .map{ text -> Bool in
                return text!.count >= 2
            }
            .share(replay: 1)
        isEventNameValid.subscribe(onNext: { (isValid) in
            if !isValid{
                self.buttonAddEvent.themeDisabledGreyButton(false)
                
            }else{
                self.buttonAddEvent.isEnabled = true
                self.buttonAddEvent.themeRedButton()
            }
        }).disposed(by: disposeBag)
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

extension EventAttendanceListViewController:ViewCourseSelectionDelegate{
    func submitSelectedCourses() {
        self.selectMarkedCourses()
        self.viewCourseList.removeFromSuperview()
    }
    
    fileprivate func selectMarkedCourses() {
        let totalClass = CollegeClassManager.sharedManager.selectedCourseArray.count
        let selectedClass = CollegeClassManager.sharedManager.selectedCourseArray.filter({ $0.isSelected == true}).count
        let titleString = selectedClass == totalClass ? "All" : "\(selectedClass) Courses"
        self.buttonAllClass.setTitle(titleString, for: .normal)
    }
    
    func courseViewDismissed() {
        selectMarkedCourses()
        self.viewCourseList.removeFromSuperview()
    }
    
    
    
}
