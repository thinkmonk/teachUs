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
    var courseListData:CourseDetails!
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
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.addNewEvent
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "event_name":"\(self.textFieldEventName.text!)",
            "event_code":"\(self.textFieldEventName.text!)",
            "event_description":"\(self.textFieldEventName.text!)",
            "event_date":"\(resultDateString)",
            "course_id":"\(CollegeClassManager.sharedManager.getSelectedCourseList)"
        ]
        
        manager.apiPost(apiName: " Add new Event", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    @IBAction func showCourseList(_ sender: Any) {
        self.viewCourseList.frame = CGRect(x: 0.0, y:0.0, width: self.view.width(), height: self.view.height())
        self.view.addSubview(self.viewCourseList)
    }
    
    
    
    //MARK:- Custom Methods
    
    func initCourseSelectionView(){
        self.viewCourseList = ViewCourseSelection.instanceFromNib() as? ViewCourseSelection
        self.viewCourseList.delegate = self
        
        //init class selection list after sorting
        for course in self.courseListData.courseList{
            let selectedCourse = SelectCollegeCourse(course, true)
            CollegeClassManager.sharedManager.selectedCourseArray.append(selectedCourse)
        }
    }

    func getEvents(){
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
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func getCourseList(){
        self.dispatchGroup.enter()
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.SyllabusURL.getCourseList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        manager.apiPostWithDataResponse(apiName: " Get all Course List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.courseListData = try decoder.decode(CourseDetails.self, from: response)
                self.dispatchGroup.leave()
            }
            catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
        
    }
    
    func setUpRx(){
        let isEventNameValid: Observable<Bool> = self.textFieldEventName.rx.text
            .map{ text -> Bool in
                return text!.count >= 2
            }
            .share(replay: 1)
        isEventNameValid.subscribe(onNext: { (isValid) in
            self.buttonAddEvent.themeRedButton()
            self.buttonAddEvent.alpha = isValid ? 1 : 0
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
    func courseViewDismissed() {
        self.viewCourseList.removeFromSuperview()
    }
    
}
