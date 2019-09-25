//
//  StudentsProfileDeatilsViewController.swift
//  TeachUs
//
//  Created by ios on 5/11/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

class StudentsProfileDeatilsViewController: BaseViewController {

    @IBOutlet weak var tableStudentProfileDetails: UITableView!
    var studentProfileDetails:StudentProfileDetails?
    var parentsProfileDetails:ParentsDetails?
    var professorProfileDetails:ProfessorProfileDetails?
    var typeEditView:EditViewType!
    var arrayDataSource = [EditProfileDataSource]()
    
    var isProfessorProfileView:Bool{
        return UserManager.sharedUserManager.user! == .professor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.addGradientToNavBar()
        if isProfessorProfileView{
            self.getProfessorDetails()
        }else{
            self.getStudentDetails()
        }
        self.tableStudentProfileDetails.register(UINib(nibName: "ProfileDetailsEditTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.profileDetailsEditTableViewCell)
        self.tableStudentProfileDetails.register(UINib(nibName: "ProfileStudentIdTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell)
        self.tableStudentProfileDetails.delegate = self
        self.tableStudentProfileDetails.dataSource = self
        self.tableStudentProfileDetails.estimatedRowHeight = 15
        self.tableStudentProfileDetails.rowHeight = UITableViewAutomaticDimension
        self.tableStudentProfileDetails.contentInset =  UIEdgeInsetsMake(15.0, 0, 15.0, 0)
    }
    
    func getStudentDetails(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        
        if UserManager.sharedUserManager.user! == .student{
            manager.url = URLConstants.StudentURL.getStudentProfileDetails
        }else{
            manager.url = URLConstants.ParentsURL.getStudentProfileDetails
            parameters["email"] = UserManager.sharedUserManager.appUserCollegeDetails.studentEmail ?? ""
        }
        manager.apiPostWithDataResponse(apiName: "Get student profile", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                if UserManager.sharedUserManager.user! == .student{
                    self.studentProfileDetails = try decoder.decode(StudentProfileDetails.self, from: response)
                    self.makeDataSource()
                }else if UserManager.sharedUserManager.user! == .parents{
                    self.parentsProfileDetails = try decoder.decode(ParentsDetails.self, from: response)
                    self.makeParentsDataSource()
                }
                
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    
    
    func makeDataSource(){
        self.arrayDataSource.removeAll()
        
        if let id = self.studentProfileDetails?.studentDetails?.studentID{
            let idDs = EditProfileDataSource(profileCell: .id, profileObject: id)
            self.arrayDataSource.append(idDs)
        }
        
        if let firstName = self.studentProfileDetails?.studentDetails?.fName, let middleName = self.studentProfileDetails?.studentDetails?.mName ,let lastName = self.studentProfileDetails?.studentDetails?.lName{
            let nameDs = EditProfileDataSource(profileCell: .name, profileObject: "\(firstName) \(middleName) \(lastName)")
            self.arrayDataSource.append(nameDs)
        }
        
        if let contactNumber = self.studentProfileDetails?.studentDetails?.contact {
            let contactDs = EditProfileDataSource(profileCell: .number, profileObject: contactNumber)
            self.arrayDataSource.append(contactDs)
        }
        
        if let emailId = self.studentProfileDetails?.studentDetails?.email{
            let emailDs = EditProfileDataSource(profileCell: .email, profileObject: emailId)
            self.arrayDataSource.append(emailDs)
        }
        
        for college in self.studentProfileDetails?.collegeDetails ?? []{
            if let collegeName = college.collegeName{
                let collegeNameDs = EditProfileDataSource(profileCell: .collegeName, profileObject: collegeName)
                self.arrayDataSource.append(collegeNameDs)
            }
        }
        
        for classDetails in self.studentProfileDetails?.classDetails ?? []{
            if let courseName = classDetails.courseName{
                let courseNameDs = EditProfileDataSource(profileCell: .courseName, profileObject: courseName)
                self.arrayDataSource.append(courseNameDs)
            }
            
            if let yearName = classDetails.yearName{
                let yearNameDs = EditProfileDataSource(profileCell: .typeYear, profileObject: yearName)
                self.arrayDataSource.append(yearNameDs)
            }
            
            if let semesterDetails = classDetails.semester{
                let semesterDs = EditProfileDataSource(profileCell: .semester, profileObject: semesterDetails)
                self.arrayDataSource.append(semesterDs)
            }
        }
        
        let subjectTitleDs = EditProfileDataSource(profileCell: .subjectTitle, profileObject: nil)
        self.arrayDataSource.append(subjectTitleDs)

        for subject in self.studentProfileDetails?.subjectDetails ?? []{
            if let subjectName = subject.subjectName{
                let subjectDs = EditProfileDataSource(profileCell: .subjectList, profileObject: subjectName)
                self.arrayDataSource.append(subjectDs)
            }
        }
        
        DispatchQueue.main.async {
            self.tableStudentProfileDetails.reloadData()
        }
    }
    
    
    func makeParentsDataSource(){
        self.arrayDataSource.removeAll()
        
        if let id = UserManager.sharedUserManager.appUserDetails.login_id{
            let idDs = EditProfileDataSource(profileCell: .id, profileObject: id)
            self.arrayDataSource.append(idDs)
        }
        
        
        if let parentFirstName = UserManager.sharedUserManager.appUserDetails.firstName,
            let lastName = UserManager.sharedUserManager.appUserDetails.lastName{
            let nameDs = EditProfileDataSource(profileCell: .name, profileObject: "\(parentFirstName) \(lastName)")
            self.arrayDataSource.append(nameDs)
        }

        if let contactNumber = UserManager.sharedUserManager.appUserDetails.contact {
            let contactDs = EditProfileDataSource(profileCell: .number, profileObject: contactNumber)
            self.arrayDataSource.append(contactDs)
        }
        
        for student in self.parentsProfileDetails?.student ?? []{
            if let studentName = student.studentDetails?.fullName{
                let studentNameDs = EditProfileDataSource(profileCell: .studetnCollegeName, profileObject: studentName)
                self.arrayDataSource.append(studentNameDs)
            }
            
            if let collegeName = student.collegeDetails?.first?.collegeName{
                let studentCollegeDs = EditProfileDataSource(profileCell: .studetnCollegeName, profileObject: collegeName)
                self.arrayDataSource.append(studentCollegeDs)
            }
            
            if let year = student.classDetails?.first?.yearName, let studentClass  = student.classDetails?.first?.courseCode{
                let studetnClassDS = EditProfileDataSource(profileCell: .studentClass, profileObject: "\(year) \(studentClass)")
                self.arrayDataSource.append(studetnClassDS)
            }
            
            if let division = student.classDetails?.first?.classDivision{
                let studentClassDs = EditProfileDataSource(profileCell: .studentDivision, profileObject: division)
                self.arrayDataSource.append(studentClassDs)
            }
            
            
            if let rollNumber = student.studentDetails?.rollNumber{
                let rollnumberds = EditProfileDataSource(profileCell: .rollNumber, profileObject: rollNumber)
                self.arrayDataSource.append(rollnumberds)
            }
        }
        
        
        
        DispatchQueue.main.async {
            self.tableStudentProfileDetails.reloadData()
        }
    }
    
    
    @objc func didEditUserInfo(_ sender:ButtonWithIndexPath){
        
        let selectedRow = sender.indexPath.row
        let editDs = self.arrayDataSource[selectedRow]
        switch editDs.cellType!{
        case .name :
            self.typeEditView = .EditName
            self.performSegue(withIdentifier: Constants.segues.toEditProfileDetails, sender: self)
        case .email:
            self.typeEditView = .EditEmail
            self.performSegue(withIdentifier: Constants.segues.toEditProfileDetails, sender: self)
        case .number:
            self.typeEditView = .EditMobileNumber
            self.performSegue(withIdentifier: Constants.segues.toEditProfileDetails, sender: self)
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toEditProfileDetails{
            if let destinationVC = segue.destination as? EditProfileDetailsViewController{
                destinationVC.viewType = self.typeEditView
                if(self.isProfessorProfileView){
                    destinationVC.professorProfileDetails = self.professorProfileDetails
                }else{
                    destinationVC.studentDetails = self.studentProfileDetails
                }
                destinationVC.delegate = self
            }
        }
    }
    
}

//MARK:- For professor's profile
extension StudentsProfileDeatilsViewController{
    func getProfessorDetails(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.ProfessorURL.getProfessorProfileDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        manager.apiPostWithDataResponse(apiName: "Get professor profile", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.professorProfileDetails = try decoder.decode(ProfessorProfileDetails.self, from: response)
                self.makeProfessorDataSource()
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func makeProfessorDataSource(){
        self.arrayDataSource.removeAll()
        
        
        if let id = self.professorProfileDetails?.professorDetails?.uniqueLoginID{
            let idDs = EditProfileDataSource(profileCell: .id, profileObject: id)
            self.arrayDataSource.append(idDs)
        }
        
        if let firstName = self.professorProfileDetails?.professorDetails?.fName {
            let nameDs = EditProfileDataSource(profileCell: .name, profileObject: "\(firstName)")
            self.arrayDataSource.append(nameDs)
        }
        
        if let contactNumber = self.professorProfileDetails?.professorDetails?.contact {
            let contactDs = EditProfileDataSource(profileCell: .number, profileObject: contactNumber)
            self.arrayDataSource.append(contactDs)
        }
        
        if let emailId = self.professorProfileDetails?.professorDetails?.email{
            let emailDs = EditProfileDataSource(profileCell: .email, profileObject: emailId)
            self.arrayDataSource.append(emailDs)
        }
        
        for college in self.professorProfileDetails?.data ?? []{
            if let collegeName = college.collegeName{
                let collegeNameDs = EditProfileDataSource(profileCell: .professorCollegeName, profileObject: collegeName)
                self.arrayDataSource.append(collegeNameDs)
            }
            if let role = college.role{
                let collegeNameDs = EditProfileDataSource(profileCell: .professorRole, profileObject: role)
                self.arrayDataSource.append(collegeNameDs)
            }
            
            
            for course in college.courseDetails ?? []{
                if let courseName = course.courseName{
                    let courseNameDs = EditProfileDataSource(profileCell: .courseName, profileObject: courseName)
                    self.arrayDataSource.append(courseNameDs)
                }
                
                if let yearName = course.yearName{
                    let yearNameDs = EditProfileDataSource(profileCell: .typeYear, profileObject: yearName)
                    self.arrayDataSource.append(yearNameDs)
                }
                
                if let semesterDetails = course.semester{
                    let semesterDs = EditProfileDataSource(profileCell: .semester, profileObject: semesterDetails)
                    self.arrayDataSource.append(semesterDs)
                }
                
                if let divisionName = course.classDivision {
                    let divisionDs = EditProfileDataSource(profileCell: .division, profileObject: divisionName)
                    self.arrayDataSource.append(divisionDs)
                }
                
                if let subjectName = course.subjects?.joined(separator: ","){
                    let subjectTitleDs = EditProfileDataSource(profileCell: .subjectName, profileObject: subjectName)
                    self.arrayDataSource.append(subjectTitleDs)
                    
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableStudentProfileDetails.reloadData()
        }
    }
    
}

//MARK:- TABLEVIEW DELEGATES
extension StudentsProfileDeatilsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datasource = self.arrayDataSource[indexPath.row]
        
        switch datasource.cellType! {
        case .id:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let studentID = datasource.attachedObject as? String{
                cell.labelKey.text = "ID"
                cell.labelValue.text = studentID
            }
            cell.viewCellWrapper.backgroundColor = .lightGray
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            return cell
        
        
        case .name:
            let cell:ProfileDetailsEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileDetailsEditTableViewCell, for: indexPath) as! ProfileDetailsEditTableViewCell
            if let name = datasource.attachedObject as? String{
                cell.labelKey.text = "Full Name"
                cell.labelValue.text = name
            }
            cell.buttonEditDetails.indexPath = indexPath
            cell.buttonEditDetails.addTarget(self, action: #selector(StudentsProfileDeatilsViewController.didEditUserInfo(_:)), for: .touchUpInside)
            cell.viewCellWrapper.backgroundColor = .clear
            cell.viewBottomSeperator.isHidden = false
            return cell
            
            
        case .email:
            let cell:ProfileDetailsEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileDetailsEditTableViewCell, for: indexPath) as! ProfileDetailsEditTableViewCell
            if let email = datasource.attachedObject as? String{
                cell.labelKey.text = "Email"
                cell.labelValue.text = email
            }
            cell.buttonEditDetails.indexPath = indexPath
            cell.buttonEditDetails.addTarget(self, action: #selector(StudentsProfileDeatilsViewController.didEditUserInfo(_:)), for: .touchUpInside)
            cell.viewCellWrapper.backgroundColor = .clear
            cell.viewBottomSeperator.isHidden = false
            return cell
            
        case .number:
            let cell:ProfileDetailsEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileDetailsEditTableViewCell, for: indexPath) as! ProfileDetailsEditTableViewCell
            if let mobileNumber = datasource.attachedObject as? String{
                cell.labelKey.text = "Contact Number"
                cell.labelValue.text = mobileNumber
            }
            cell.buttonEditDetails.indexPath = indexPath
            cell.buttonEditDetails.addTarget(self, action: #selector(StudentsProfileDeatilsViewController.didEditUserInfo(_:)), for: .touchUpInside)
            cell.viewCellWrapper.backgroundColor = .clear
            cell.viewBottomSeperator.isHidden = false
            return cell
            
        case .collegeName:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let collegeName = datasource.attachedObject as? String{
                cell.labelKey.text = "College Name"
                cell.labelValue.text = collegeName
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            cell.backgroundColor = .white
            return cell
            
        case .courseName:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let courseName = datasource.attachedObject as? String{
                cell.labelKey.text = "Course Name"
                cell.labelValue.text = courseName
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = false
            cell.viewBottomSeperator.isHidden = true

            return cell
            
        case .typeYear:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let year = datasource.attachedObject as? String{
                cell.labelKey.text = "Year"
                cell.labelValue.text = year
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            return cell
            
        case .semester:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let sem = datasource.attachedObject as? String{
                cell.labelKey.text = "Semester"
                cell.labelValue.text = sem
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.viewBottomSeperator.isHidden = false
            cell.labelColon.isHidden = false
            return cell
            
        case .subjectTitle:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            cell.labelKey.text = "Subject"
            cell.labelValue.text = ""
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell
            
            
        case .subjectList:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let subjectName = datasource.attachedObject as? String{
                cell.labelKey.text = ""
                cell.labelValue.text = subjectName
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell

        case .division:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let division = datasource.attachedObject as? String{
                cell.labelKey.text = "Division"
                cell.labelValue.text = division
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell

        case .subjectName:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let subjectName = datasource.attachedObject as? String{
                cell.labelKey.text = "Subject"
                cell.labelValue.text = subjectName
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = false
            cell.viewBottomSeperator.isHidden = false
            return cell

        case .professorCollegeName:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let collegeName = datasource.attachedObject as? String{
                cell.labelKey.text = "College Name"
                cell.labelValue.text = collegeName
            }
            cell.viewCellWrapper.backgroundColor = .lightGray
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            cell.backgroundColor = .lightGray
            return cell
            
        case .professorRole:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let role = datasource.attachedObject as? String{
                cell.labelKey.text = "Role"
                cell.labelValue.text = role
            }
            cell.viewCellWrapper.backgroundColor = .lightGray
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            cell.backgroundColor = .lightGray
            return cell
            
        case .studentName:
            let cell:ProfileDetailsEditTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileDetailsEditTableViewCell, for: indexPath) as! ProfileDetailsEditTableViewCell
            if let name = datasource.attachedObject as? String{
                cell.labelKey.text = "Full Name"
                cell.labelValue.text = name
            }
            cell.buttonEditDetails.indexPath = indexPath
            cell.buttonEditDetails.addTarget(self, action: #selector(StudentsProfileDeatilsViewController.didEditUserInfo(_:)), for: .touchUpInside)
            cell.viewCellWrapper.backgroundColor = .lightGray
            cell.viewBottomSeperator.isHidden = false
            return cell
            
        case .studetnCollegeName:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let collegeName = datasource.attachedObject as? String{
                cell.labelKey.text = "College"
                cell.labelValue.text = collegeName
            }
            cell.viewCellWrapper.backgroundColor = .lightGray
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            cell.backgroundColor = .lightGray
            return cell

        case .studentClass:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let className = datasource.attachedObject as? String{
                cell.labelKey.text = "Class"
                cell.labelValue.text = className
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell
            
        case .studentDivision:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let division = datasource.attachedObject as? String{
                cell.labelKey.text = "Division"
                cell.labelValue.text = division
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell
            
        case .rollNumber:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let role = datasource.attachedObject as? String{
                cell.labelKey.text = "Roll Number"
                cell.labelValue.text = role
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            cell.backgroundColor = .white
            return cell
        }
    }
    
    
}

extension StudentsProfileDeatilsViewController:EditProfileDetailsDelegate{
    func profileDetailsEdited() {
        if isProfessorProfileView{
            self.getProfessorDetails()
        }else{
            self.getStudentDetails()
        }
    }
}
