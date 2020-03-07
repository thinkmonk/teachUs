//
//  EventAttendanceClassListViewController.swift
//  TeachUs
//
//  Created by ios on 4/8/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper



class EventAttendanceClassListViewController: BaseViewController {

    var currentEvent:Event!
    var arrayDataSource:[ClassList] = []
    
    @IBOutlet weak var tableViewClassList: UITableView!
    @IBOutlet weak var buttonConfirm: UIButton!
    var viewCourseList : ViewCourseSelection!
    var classObj :ClassListObj?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.buttonConfirm.themeRedButton()
        self.tableViewClassList.register(UINib(nibName: "ClassListTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.ClassListTableViewCellId)
        self.tableViewClassList.dataSource = self
        self.tableViewClassList.delegate = self
        self.tableViewClassList.alpha = 0
        self.title = "\(self.currentEvent.eventName)"
        self.buttonConfirm.alpha = 0
        let buttonEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(EventAttendanceClassListViewController.editClassForEvents))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(EventAttendanceClassListViewController.deleteEvent))
        self.navigationItem.rightBarButtonItems = [delete, buttonEdit]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getClassList()
    }

    //MARK:- Custom functions
    func getClassList()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getClassList
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "event_id":"\(self.currentEvent.eventId)"
        ]
        
        manager.apiPostWithDataResponse(apiName: " Get all class", parameters:parameters, completionHandler: { [weak self] (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self?.classObj  = try decoder.decode(ClassListObj.self, from: response)
                self?.arrayDataSource.removeAll()
                for classObj in self?.classObj?.classList ?? []{
                    self?.arrayDataSource.append(classObj)
                }
                self?.arrayDataSource.sort(by: { ($0.year ?? "", $0.courseName ?? "", $0.classDivision ?? "") < ($1.year ?? "", $1.courseName ?? "", $1.classDivision ?? "") })
                self?.tableViewClassList.reloadData()
                self?.showTableView()
            } catch let error{
                print(error)
                self?.showErrorAlert(.ParsingError, retry: { (retry) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
            
        }) { [weak self] (error, code, message) in
            self?.showAlertWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableViewClassList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewClassList.alpha = 1.0
            self.tableViewClassList.transform = CGAffineTransform.identity
        }
    }
    
    @objc func editClassForEvents(){
        if self.viewCourseList == nil{
            self.viewCourseList = ViewCourseSelection.instanceFromNib() as? ViewCourseSelection
            self.viewCourseList.delegate = self
        }
        
        if CollegeClassManager.sharedManager.courseListData == nil{
            CollegeClassManager.sharedManager.getCourseList(completion: nil)
        }
        self.viewCourseList.frame = CGRect(x: 0.0, y:self.statusBarHeight+self.navBarHeight, width: self.view.width(), height: self.view.height()-(self.statusBarHeight+self.navBarHeight))
        self.viewCourseList.selecCourses(courseIdArray: self.currentEvent.courseSpecificArray)
        self.view.addSubview(self.viewCourseList)
    }
    
    @objc func deleteEvent(){
        switch self.classObj?.deleteStatus {
        case .currentUser: //flag == 1
            let alert = UIAlertController(title: nil, message: "Are you sure, you want to delete this event?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                self.deleteEventApiCall()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion:nil)
            
        case .defaultFlag:// cannot delete //flag == 0
            self.showAlertWithTitle("", alertMessage: "Only the notice creator can delete this notice")
            
        case .otherUser: //attendance already marked //flag == 2
            self.showAlertWithTitle("", alertMessage: "You can't delete this event, since attendance is marked")
            
        case .none:
            break
        }
    }
    
    func deleteEventApiCall(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.deleteEvent
        let parameters:[String:Any] =
            [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code ?? "")",
                "event_id":"\(self.currentEvent.eventId)",
        ]
        manager.apiPost(apiName: "Delete Event \(self.currentEvent.eventName)", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if (code == 200){
                let message = response["message"] as? String
                let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    NotificationCenter.default.post(name: .eventDeleted, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion:nil)
            }else{
                self.showAlertWithTitle("Error", alertMessage: "Unable to delete.")
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toStudentList {
            let destinatonVc:EventAttendanceStudentListViewController = segue.destination as! EventAttendanceStudentListViewController
            destinatonVc.classList = self.arrayDataSource[self.tableViewClassList.indexPathForSelectedRow!.section]
            destinatonVc.delegate = self
            destinatonVc.currentEvent = self.currentEvent
        }
    }
}


extension EventAttendanceClassListViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClassListTableViewCell = self.tableViewClassList.dequeueReusableCell(withIdentifier: Constants.CustomCellId.ClassListTableViewCellId, for: indexPath) as! ClassListTableViewCell
        let classObj = self.arrayDataSource[indexPath.section]
        cell.labelClassName.text = "\(classObj.courseName ?? "")\(classObj.classDivision.addHyphenToString())"
        cell.labelParticipantCount.text = self.arrayDataSource[indexPath.section].totalParticipants
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewClassList.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        self.performSegue(withIdentifier: Constants.segues.toStudentList, sender: self)
    }
}

extension EventAttendanceClassListViewController:AddEventAttendanceDelegate{
    func eventAttendanceAdded(_ message: String) {
        self.showAlertWithTitle(nil, alertMessage: message)
    }
    
    
}


extension EventAttendanceClassListViewController:ViewCourseSelectionDelegate{
    func submitSelectedCourses() {
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "course_id":"\(CollegeClassManager.sharedManager.getSelectedCourseList)",
            "event_id":"\(self.currentEvent.eventId)"
        ]
        EventManager.shared.editEvent(params: parameters) { (_) in
            self.viewCourseList.removeFromSuperview()
        }
    }
    
    func courseViewDismissed() {
        self.viewCourseList.removeFromSuperview()
    }
}
