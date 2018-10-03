//
//  EventAttendanceStudentListViewController.swift
//  TeachUs
//
//  Created by ios on 4/10/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
import Alamofire

protocol AddEventAttendanceDelegate {
    func eventAttendanceAdded(_ message:String)
}

class EventAttendanceStudentListViewController: BaseViewController {

  //  var searchButton: UIButton!
    var searchItem: UIBarButtonItem!
    var searchBar: UISearchBar!
    var classList:ClassList!
    var currentEvent:Event!
    var arrayDataSource:[EventStudents] = []
    var arrayAllStudentsDataSource:[EventStudents] = []
    var arraySearchDataSource:[EventStudents] = []
    var totalParticipants :Int!
    let disposeBag = DisposeBag()
    var delegate:AddEventAttendanceDelegate!
    
    @IBOutlet weak var labelClass: UILabel!
    @IBOutlet weak var labelTotalParticipants: UILabel!
    @IBOutlet weak var tableViewStudentList: UITableView!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.tableViewStudentList.register(UINib(nibName: "EventStudentListTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.EventStudentListTableViewCellId)
        self.tableViewStudentList.delegate = self
        self.tableViewStudentList.dataSource  = self
        self.tableViewStudentList.estimatedRowHeight = 55
        self.tableViewStudentList.rowHeight = UITableViewAutomaticDimension
        self.tableViewStudentList.alpha = 0


        searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(EventAttendanceStudentListViewController.searchButtonTapped(_:)))
        navigationItem.rightBarButtonItem = searchItem
        searchBar = UISearchBar()
        searchBar?.showsCancelButton = true
        searchBar?.delegate = self
        self.title = "\(self.classList.courseName) - \(self.classList.classDivision)"
        
        self.buttonConfirm.themeRedButton()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewHeader.makeTableCellEdgesRounded()
        self.getStudentList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Outlet methods
    @IBAction func submitEventAttendance(_ sender: Any) {
//        print(EventAttendanceManager.sharedEventAttendanceManager.attendanceListJSON)
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.markEventAttendance
/*
         requestString = {"student_list":[{"student_id":"4","attendance":"6"},{"student_id":"5","attendance":"4"},{"student_id":"6","attendance":"4"},{"student_id":"7","attendance":"2"},{"student_id":"8","attendance":"3"},{"student_id":"9","attendance":"3"},{"student_id":"10","attendance":"1"},{"student_id":"11","attendance":"1"},{"student_id":"12","attendance":"1"},{"student_id":"13","attendance":"1"},{"student_id":"14","attendance":"1"},{"student_id":"15","attendance":"1"},{"student_id":"16","attendance":"3"},{"student_id":"17","attendance":"0"},{"student_id":"18","attendance":"0"},{"student_id":"19","attendance":"0"},{"student_id":"22","attendance":"0"},{"student_id":"23","attendance":"0"},{"student_id":"24","attendance":"0"}]}
         Add event attendance parameters ["college_code": "gsc", "event_id": "5", "class_id": "1", "student_list": "{\"student_list\":[{\"student_id\":\"4\",\"attendance\":\"6\"},{\"student_id\":\"5\",\"attendance\":\"4\"},{\"student_id\":\"6\",\"attendance\":\"4\"},{\"student_id\":\"7\",\"attendance\":\"2\"},{\"student_id\":\"8\",\"attendance\":\"3\"},{\"student_id\":\"9\",\"attendance\":\"3\"},{\"student_id\":\"10\",\"attendance\":\"1\"},{\"student_id\":\"11\",\"attendance\":\"1\"},{\"student_id\":\"12\",\"attendance\":\"1\"},{\"student_id\":\"13\",\"attendance\":\"1\"},{\"student_id\":\"14\",\"attendance\":\"1\"},{\"student_id\":\"15\",\"attendance\":\"1\"},{\"student_id\":\"16\",\"attendance\":\"3\"},{\"student_id\":\"17\",\"attendance\":\"0\"},{\"student_id\":\"18\",\"attendance\":\"0\"},{\"student_id\":\"19\",\"attendance\":\"0\"},{\"student_id\":\"22\",\"attendance\":\"0\"},{\"student_id\":\"23\",\"attendance\":\"0\"},{\"student_id\":\"24\",\"attendance\":\"0\"}]}"]
        parameters = {"college_code":"gsc","event_id":"5","class_id":"1","student_list":"{\"student_list\":[{\"student_id\":\"4\",\"attendance\":\"6\"},{\"student_id\":\"5\",\"attendance\":\"4\"},{\"student_id\":\"6\",\"attendance\":\"4\"},{\"student_id\":\"7\",\"attendance\":\"2\"},{\"student_id\":\"8\",\"attendance\":\"3\"},{\"student_id\":\"9\",\"attendance\":\"3\"},{\"student_id\":\"10\",\"attendance\":\"1\"},{\"student_id\":\"11\",\"attendance\":\"1\"},{\"student_id\":\"12\",\"attendance\":\"1\"},{\"student_id\":\"13\",\"attendance\":\"1\"},{\"student_id\":\"14\",\"attendance\":\"1\"},{\"student_id\":\"15\",\"attendance\":\"1\"},{\"student_id\":\"16\",\"attendance\":\"3\"},{\"student_id\":\"17\",\"attendance\":\"0\"},{\"student_id\":\"18\",\"attendance\":\"0\"},{\"student_id\":\"19\",\"attendance\":\"0\"},{\"student_id\":\"22\",\"attendance\":\"0\"},{\"student_id\":\"23\",\"attendance\":\"0\"},{\"student_id\":\"24\",\"attendance\":\"0\"}]}"}

 */
        var requestString = ""
        let attendance = EventAttendanceManager.sharedEventAttendanceManager.attendanceJSON
        if let theJSONData = try? JSONSerialization.data(withJSONObject: attendance,options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            requestString = theJSONText!
            print("requestString = \(theJSONText!)")
        }
        
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "event_id":"\(self.currentEvent.eventId)",
            "class_id":"\(self.classList.classId)",
            "student_list":requestString
            ] as [String : Any]
       print("Add event attendance parameters \(parameters)")
        manager.apiPost(apiName: " Mark event attendance", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.navigationController?.popViewController(animated: true)
                if self.delegate != nil{
                    self.delegate.eventAttendanceAdded(message)
                }
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func getStudentList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getStudentList
        
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "event_id":"\(self.currentEvent.eventId)",
            "class_id":"\(self.classList.classId)"
        ]
        
        manager.apiPost(apiName: " Get all class", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let totalStudents = response["total_participants"] as? String else{
                return
            }
            self.totalParticipants = Int(totalStudents)
            guard let studentArray = response["student_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for student in studentArray{
                let tempStudent = Mapper<EventStudents>().map(JSONObject: student)
                self.arrayDataSource.append(tempStudent!)
            }
            self.arrayDataSource.sort(by: { $0.rollNumber.localizedStandardCompare($1.rollNumber) == .orderedAscending})

            self.arraySearchDataSource = self.arrayDataSource
            self.arrayAllStudentsDataSource = self.arrayDataSource
            
            EventAttendanceManager.sharedEventAttendanceManager.arrayStudents.value.removeAll()
            EventAttendanceManager.sharedEventAttendanceManager.arrayStudents.value = self.arrayAllStudentsDataSource
//            EventAttendanceManager.sharedEventAttendanceManager.updateCount()
//            EventAttendanceManager.sharedEventAttendanceManager.totalPresentCount.asObservable().subscribe(onNext: { (count) in
//                self.labelTotalParticipants.text = "\(count)"
//            }).disposed(by: self.disposeBag)
            self.labelClass.text = "\(self.classList.courseName) - \(self.classList.classDivision)"
            self.labelTotalParticipants.text  = "\(self.totalParticipants!)"
            self.tableViewStudentList.reloadData()
            self.showTableView()
            
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableViewStudentList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewStudentList.alpha = 1.0
            self.tableViewStudentList.transform = CGAffineTransform.identity
        }
    }
    
    @objc func searchButtonTapped(_ sender: Any?) {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        
        self.navigationItem.titleView = self.searchBar
        self.searchBar.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.searchBar.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            self.searchBar.becomeFirstResponder()
        })
    }

    func hideSearchBar() {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.searchBar.alpha = 0.0
        }, completion: {(_ finished: Bool) -> Void in
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = self.searchItem
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.navigationController?.navigationBar.topItem?.hidesBackButton = false
            })
        })
    }


}


extension EventAttendanceStudentListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventStudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.EventStudentListTableViewCellId, for: indexPath) as! EventStudentListTableViewCell
        cell.setUpCellForStudent(student: self.arrayDataSource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}


extension EventAttendanceStudentListViewController:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
        self.arrayDataSource  = self.arrayAllStudentsDataSource
        self.tableViewStudentList.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.arraySearchDataSource  = self.arrayAllStudentsDataSource.filter { $0.fullname.lowercased().contains(searchText.lowercased()) || $0.rollNumber.contains(searchText) }
        self.arrayDataSource = self.arraySearchDataSource
        self.tableViewStudentList.reloadData()
    }
    
}
