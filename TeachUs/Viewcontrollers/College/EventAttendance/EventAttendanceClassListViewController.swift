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
        
        manager.apiPost(apiName: " Get all class", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let classArray = response["class_list"] as? [[String:Any]] else{
                return
            }
            self.arrayDataSource.removeAll()
            for className in classArray{
                let tempEvent = Mapper<ClassList>().map(JSONObject: className)
                self.arrayDataSource.append(tempEvent!)
            }
            
            self.arrayDataSource.sort(by: { ($0.year, $0.courseName, $0.classDivision) < ($1.year, $1.courseName, $1.classDivision) })
            self.tableViewClassList.reloadData()
            self.showTableView()
            
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
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
        cell.labelClassName.text = "\(self.arrayDataSource[indexPath.section].courseName) - \(self.arrayDataSource[indexPath.section].classDivision)"
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
        self.showAlterWithTitle(nil, alertMessage: message)
    }
    
    
}
