//
//  CollegeAttendanceDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 3/30/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

class CollegeAttendanceDetailsViewController: BaseViewController {

    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textFieldToDate: UITextField!
    @IBOutlet weak var buttonFromDate: UIButton!
    @IBOutlet weak var buttonToDate: UIButton!
    @IBOutlet weak var tableViewStudentList: UITableView!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var buttonAllSubject: UIButton!
    @IBOutlet weak var viewSubjectName: UIView!
    @IBOutlet weak var labelNoRecordFound: UILabel!
    var arraySubjectLIst:[CollegeSubjects] = []
    var arrayStudentList:[EnrolledStudentDetail] = []
    let collegeSubjectDropdown = DropDown()
    var collegeClass:CollegeAttendanceList!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelNoRecordFound.alpha = 0
        self.buttonSubmit.makeEdgesRounded()
        self.addGradientToNavBar()
        getSubjectList()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CollegeAttendanceDetailsViewController.showDropDown(_:)))
        self.labelSubject.isUserInteractionEnabled = true
        self.labelSubject.addGestureRecognizer(tap)

        
        self.tableViewStudentList.register(UINib(nibName: "StudentProfileTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.StudentProfileTableViewCellId)
        self.tableViewStudentList.delegate = self
        self.tableViewStudentList.dataSource = self
        self.tableViewStudentList.estimatedRowHeight = 80
        self.tableViewStudentList.rowHeight = UITableViewAutomaticDimension
        self.tableViewStudentList.alpha = 0.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSubjectList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classSubjectList
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.collegeClass.classId)"
        ]
        
        manager.apiPost(apiName: " Get class Subject List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let subjectListArray = response["subject_list"] as? [[String:Any]] else{
                return
            }
            for subject in subjectListArray{
                let tempList = Mapper<CollegeSubjects>().map(JSONObject: subject)
                self.arraySubjectLIst.append(tempList!)
            }
            self.setUpDropDown()
            self.getAttendance(subject: nil)
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    func setUpDropDown(){
        self.collegeSubjectDropdown.anchorView = self.labelSubject
        self.collegeSubjectDropdown.bottomOffset = CGPoint(x: 0, y: viewSubjectName.height())
        self.collegeSubjectDropdown.width = self.view.width() * 0.80
        
        for subject in arraySubjectLIst{
            self.collegeSubjectDropdown.dataSource.append(subject.subjectName!)
            
            self.collegeSubjectDropdown.selectionAction = { [unowned self] (index, item) in
                print(item)
                self.labelSubject.text = "\(self.arraySubjectLIst[index].subjectName ?? "")"
                self.getAttendance(subject: self.arraySubjectLIst[index])
            }
        }
    }
    
    func getAttendance( subject:CollegeSubjects?){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        self.arrayStudentList.removeAll()
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.classStudentLIst
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id":"\(self.collegeClass.classId)",
            "subject_id":"\(subject?.subjectId! ?? "0")",
        ]
        
        if(!(textFieldFromDate.text?.isEmpty)!)
        {
            parameters["from_date"] = textFieldFromDate.text!
        }
        
        if(!(textFieldToDate.text?.isEmpty)!)
        {
            parameters["from_date"] = textFieldToDate.text!
        }
        
        manager.apiPost(apiName: " Get class Student List", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let studentListArray = response["student_list"] as? [[String:Any]] else{
                self.tableViewStudentList.reloadData()
                self.labelNoRecordFound.alpha = 1
                return
            }
            self.labelNoRecordFound.alpha = 0

            for student in studentListArray{
                let tempList = Mapper<EnrolledStudentDetail>().map(JSONObject: student)
                self.arrayStudentList.append(tempList!)
            }            
            self.showTableView()
            self.tableViewStudentList.reloadData()
            
        }) { (error, code, message) in
            print(message)
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
    
    @IBAction func showDropDown(_ sender: Any) {
        self.collegeSubjectDropdown.show()
    }
    
    
    
    @IBAction func getAttendanceForAllSubjects(_ sender: Any) {
        self.getAttendance(subject: nil)
        self.labelSubject.text = "All Subjects"
    }
}


extension CollegeAttendanceDetailsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayStudentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : StudentProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.StudentProfileTableViewCellId, for: indexPath) as! StudentProfileTableViewCell
        let object:EnrolledStudentDetail = arrayStudentList [indexPath.row]
        cell.labelName.text = object.studentName
        cell.labelRollNumber.text = "\(object.studentRollNo! )"
        cell.labelAttendanceCount.text = "\(object.totalLecture! )"
        cell.labelAttendancePercent.text = "\(object.percentage! ) %"
        cell.clipsToBounds = true
        print("Image URL \(object.imageUrl)")
        cell.imageViewProfile.imageFromServerURL(urlString: (object.imageUrl!), defaultImage: Constants.Images.studentDefault)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}



