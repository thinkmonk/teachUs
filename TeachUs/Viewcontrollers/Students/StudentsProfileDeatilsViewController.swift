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
    var typeEditView:EditViewType!
    var arrayDataSource = [EditProfileDataSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.addGradientToNavBar()
        self.getStudentDetails()
        self.tableStudentProfileDetails.register(UINib(nibName: "ProfileDetailsEditTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.profileDetailsEditTableViewCell)
        self.tableStudentProfileDetails.register(UINib(nibName: "ProfileStudentIdTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell)
        self.tableStudentProfileDetails.delegate = self
        self.tableStudentProfileDetails.dataSource = self
        self.tableStudentProfileDetails.estimatedRowHeight = 30
        self.tableStudentProfileDetails.rowHeight = UITableViewAutomaticDimension
        self.tableStudentProfileDetails.contentInset =  UIEdgeInsetsMake(15.0, 0, 15.0, 0)
    }
    
    func getStudentDetails(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.StudentURL.getStudentProfileDetails
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        ]
        manager.apiPostWithDataResponse(apiName: "Get student profile", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                self.studentProfileDetails = try decoder.decode(StudentProfileDetails.self, from: response)
                self.makeDataSource()
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
            let idDs = EditProfileDataSource(profileCell: .cellTypeId, profileObject: id)
            self.arrayDataSource.append(idDs)
        }
        
        if let firstName = self.studentProfileDetails?.studentDetails?.fName, let middleName = self.studentProfileDetails?.studentDetails?.mName ,let lastName = self.studentProfileDetails?.studentDetails?.lName{
            let nameDs = EditProfileDataSource(profileCell: .cellTypeName, profileObject: "\(firstName) \(middleName) \(lastName)")
            self.arrayDataSource.append(nameDs)
        }
        
        if let contactNumber = self.studentProfileDetails?.studentDetails?.contact {
            let contactDs = EditProfileDataSource(profileCell: .cellTypeMobileNumber, profileObject: contactNumber)
            self.arrayDataSource.append(contactDs)
        }
        
        if let emailId = self.studentProfileDetails?.studentDetails?.email{
            let emailDs = EditProfileDataSource(profileCell: .cellTypeEmail, profileObject: emailId)
            self.arrayDataSource.append(emailDs)
        }
        
        for college in self.studentProfileDetails?.collegeDetails ?? []{
            if let collegeName = college.collegeName{
                let collegeNameDs = EditProfileDataSource(profileCell: .cellTypecollegeName, profileObject: collegeName)
                self.arrayDataSource.append(collegeNameDs)
            }
        }
        
        for classDetails in self.studentProfileDetails?.classDetails ?? []{
            if let courseName = classDetails.courseName{
                let courseNameDs = EditProfileDataSource(profileCell: .cellTypeCourseName, profileObject: courseName)
                self.arrayDataSource.append(courseNameDs)
            }
            
            if let yearName = classDetails.yearName{
                let yearNameDs = EditProfileDataSource(profileCell: .cellTypeYear, profileObject: yearName)
                self.arrayDataSource.append(yearNameDs)
            }
            
            if let semesterDetails = classDetails.semester{
                let semesterDs = EditProfileDataSource(profileCell: .cellTypeSemester, profileObject: semesterDetails)
                self.arrayDataSource.append(semesterDs)
            }
        }
        
        let subjectTitleDs = EditProfileDataSource(profileCell: .cellTypeSubjectTitle, profileObject: nil)
        self.arrayDataSource.append(subjectTitleDs)

        for subject in self.studentProfileDetails?.subjectDetails ?? []{
            if let subjectName = subject.subjectName{
                let subjectDs = EditProfileDataSource(profileCell: .cellTypeSubjectList, profileObject: subjectName)
                self.arrayDataSource.append(subjectDs)
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
        case .cellTypeName :
            self.typeEditView = .EditName
            self.performSegue(withIdentifier: Constants.segues.toEditProfileDetails, sender: self)
        case .cellTypeEmail:
            self.typeEditView = .EditEmail
            self.performSegue(withIdentifier: Constants.segues.toEditProfileDetails, sender: self)
        case .cellTypeMobileNumber:
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
                destinationVC.studentDetails = self.studentProfileDetails
                destinationVC.delegate = self
            }
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
        case .cellTypeId:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let studentID = datasource.attachedObject as? String{
                cell.labelKey.text = "ID"
                cell.labelValue.text = studentID
            }
            cell.viewCellWrapper.backgroundColor = .lightGray
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            return cell
        
        
        case .cellTypeName:
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
            
            
        case .cellTypeEmail:
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
            
        case .cellTypeMobileNumber:
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
            
        case .cellTypecollegeName:
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
            
        case .cellTypeCourseName:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let courseName = datasource.attachedObject as? String{
                cell.labelKey.text = "Course Name"
                cell.labelValue.text = courseName
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = false
            cell.viewBottomSeperator.isHidden = true

            return cell
            
        case .cellTypeYear:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let year = datasource.attachedObject as? String{
                cell.labelKey.text = "Year"
                cell.labelValue.text = year
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.viewBottomSeperator.isHidden = true
            cell.labelColon.isHidden = false
            return cell
            
        case .cellTypeSemester:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let sem = datasource.attachedObject as? String{
                cell.labelKey.text = "Semester"
                cell.labelValue.text = sem
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.viewBottomSeperator.isHidden = false
            cell.labelColon.isHidden = false
            return cell
            
        case .cellTypeSubjectTitle:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            cell.labelKey.text = "Subject"
            cell.labelValue.text = ""
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell
            
            
        case .cellTypeSubjectList:
            let cell:ProfileStudentIdTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.profileStudentIdTableViewCell, for: indexPath) as! ProfileStudentIdTableViewCell
            if let subjectName = datasource.attachedObject as? String{
                cell.labelKey.text = ""
                cell.labelValue.text = subjectName
            }
            cell.viewCellWrapper.backgroundColor = .white
            cell.labelColon.isHidden = true
            cell.viewBottomSeperator.isHidden = true
            return cell

        }
    }
    
    
}

extension StudentsProfileDeatilsViewController:EditProfileDetailsDelegate{
    func profileDetailsEdited() {
        self.getStudentDetails()
    }
    
    
}
