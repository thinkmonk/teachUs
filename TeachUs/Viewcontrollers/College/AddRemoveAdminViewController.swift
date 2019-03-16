//
//  AddRemoveAdminViewController.swift
//  TeachUs
//
//  Created by ios on 4/16/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import  ObjectMapper
import RxCocoa
import RxSwift
import Contacts
import ContactsUI


class AddRemoveAdminViewController: BaseViewController {

    @IBOutlet var isSuperAdmin:UISwitch!
    
    @IBOutlet weak var viewAddAdminPhoneNumber: UIView!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var tableViewAdminList: UITableView!
    @IBOutlet weak var buttonContact: UIButton!
    
    let adminDropdown = DropDown()
    var parentNavigationController : UINavigationController?
    var arrayAdminList:[Admin] = []
    let disposeBag = DisposeBag()
    var courseListData:CourseDetails!
    var dispatchGroup = DispatchGroup()
    var viewCourseList : ViewCourseSelection!

    
    
    //AddRemoveAdminTableViewCellId
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName:"AddRemoveAdminTableViewCell", bundle: nil)
        self.tableViewAdminList.estimatedRowHeight = 44
        self.tableViewAdminList.rowHeight = UITableViewAutomaticDimension
        self.tableViewAdminList.register(cellNib, forCellReuseIdentifier: Constants.CustomCellId.addRemoveAdminCell)
        self.tableViewAdminList.delegate = self
        self.tableViewAdminList.dataSource = self
        self.initContactList()
        self.tableViewAdminList.alpha = 1.0
        self.getAdminList()
        self.getCourseList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAddAdminPhoneNumber.makeViewCircular()
        self.buttonAdd.roundedRedButton()
        //self.setUpRx()

    }
    
    //MARK:- Outlet methods
    @IBAction func adminTypeChanged(_ sender: UISwitch) {
        self.getAdminList()
    }
    
    @IBAction func addNewAdmin(_ sender: Any) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.addAmin
        let adminType  = isSuperAdmin.isOn ? "1" : "2"
        let parameters = [
            "college_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_id!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "contact":"\(self.textFieldPhoneNumber.text!)",
            "admin_type":"\(adminType)",
            "courses":"\(CollegeClassManager.sharedManager.getSelectedCourseList)"
        ]
        manager.apiPost(apiName: " Add new admin", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.getAdminList()
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
   
    
    @IBAction func click_Contact(_ sender: Any) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    @IBAction func showCourseList(_ sender: Any) {
        if(self.viewCourseList != nil){
            self.viewCourseList.frame = CGRect(x: 0.0, y:0.0, width: self.view.width(), height: self.view.height())
            self.view.addSubview(self.viewCourseList)
        }
    }
    
    
    @IBAction func removeAdmin(_ sender: Any) {
        if let removeButton = sender as? ButtonWithIndexPath{
            let adminDetails = self.arrayAdminList[removeButton.indexPath.section]
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            let manager = NetworkHandler()
            manager.url = URLConstants.CollegeURL.removeAdmin
            let parameters = [
                "college_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_id!)",
                "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
                "contact":"\(adminDetails.contact)"
            ]
            manager.apiPost(apiName: " Remove admin", parameters:parameters, completionHandler: { (result, code, response) in
                LoadingActivityHUD.hideProgressHUD()
                let status = response["status"] as! Int
                if (status == 200){
                    let message:String = response["message"] as! String
                    self.showAlterWithTitle(nil, alertMessage: message)
                    self.getAdminList()
                }
            }) { (error, code, message) in
                self.showAlterWithTitle(nil, alertMessage: message)
                LoadingActivityHUD.hideProgressHUD()
            }
        }
    }
    
    //MARK:- Custom Methods
    func initContactList(){
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            presentSettingsActionSheet()
            return
        }
        
        // open it
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet()
                }
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                print(error)
            }
            
            // do something with the contacts array (e.g. print the names)
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            for contact in contacts {
                print(formatter.string(from: contact) ?? "???")
            }
        }
    }
    
    func getCourseList(){
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
                self.initCourseSelectionView()
            }
            catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
        
    }
    
    func initCourseSelectionView(){
        self.viewCourseList = ViewCourseSelection.instanceFromNib() as? ViewCourseSelection
        self.viewCourseList.delegate = self
        
        //init class selection list after sorting
        for course in self.courseListData.courseList{
            let selectedCourse = SelectCollegeCourse(course, true)
            CollegeClassManager.sharedManager.selectedCourseArray.append(selectedCourse)
        }
        
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
    func getAdminList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getAdminList
        let adminType  = isSuperAdmin.isOn ? "1" : "2"
        let parameters = [
            "college_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_id!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "admin_type":"\(adminType)"
        ]
        
        manager.apiPost(apiName: " Get all admin list", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let adminListArray = response["admin_list"] as? [[String:Any]] else{
                return
            }
            self.arrayAdminList.removeAll()
            for admin in adminListArray{
                let tempList = Mapper<Admin>().map(JSONObject: admin)
                self.arrayAdminList.append(tempList!)
            }
            self.tableViewAdminList.reloadData()
            self.showTableView()
//            self.setupDropdown()
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func showTableView(){
        self.tableViewAdminList.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewAdminList.alpha = 1.0
            self.tableViewAdminList.transform = CGAffineTransform.identity
        }
    }
    
    /*
    func setUpRx(){
        self.textfieldRemoveAdminPhoneNumber.rx.controlEvent([UIControlEvents.editingDidBegin, UIControlEvents.editingChanged])
        .asObservable()
            .subscribe(onNext: { () in
                self.adminDropdown.show()
            }).disposed(by: disposeBag)
        
        self.textfieldRemoveAdminPhoneNumber.rx.controlEvent([UIControlEvents.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { () in
                self.adminDropdown.hide()
            }).disposed(by: disposeBag)
    }
 */
    /*
    func setupDropdown(){
        self.adminDropdown.anchorView = self.viewRemoveAdminPhoneNumber
        self.adminDropdown.bottomOffset = CGPoint(x: 0, y: viewRemoveAdminPhoneNumber.height())
        self.adminDropdown.width = self.viewRemoveAdminPhoneNumber.width()
        self.adminDropdown.dataSource.removeAll()
        for admin in self.arrayAdminList{
            self.adminDropdown.dataSource.append(admin.contact)
        }
        self.adminDropdown.selectionAction = { [unowned self] (index, item) in
                self.textfieldRemoveAdminPhoneNumber.text = "\(self.arrayAdminList[index].contact)"
        }
        DropDown.appearance().backgroundColor = UIColor.white
    }
 */
}

extension AddRemoveAdminViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Add/Remove Admin")
    }
}


extension AddRemoveAdminViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayAdminList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adminCell = tableViewAdminList.dequeueReusableCell(withIdentifier: Constants.CustomCellId.addRemoveAdminCell) as! AddRemoveAdminTableViewCell
        adminCell.setUpCell(adminDetails: self.arrayAdminList[indexPath.section])
        adminCell.buttonRemoveAdmin.indexPath = indexPath
        adminCell.buttonRemoveAdmin.addTarget(self, action: #selector(AddRemoveAdminViewController.removeAdmin(_:)), for: .touchUpInside)
        return adminCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewAdminList.width(), height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension AddRemoveAdminViewController:CNContactPickerDelegate{
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//        contacts.forEach { contact in
//            for number in contact.phoneNumbers {
//                let phoneNumber = number.value
//                print("number is = \(phoneNumber)")
//            }
//        }
//    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        for number in contact.phoneNumbers {
            let phoneNumber = number.value
            print("number is = \(phoneNumber.stringValue)")
            self.textFieldPhoneNumber.text = "\(phoneNumber.stringValue)"
        }
    }
}

extension AddRemoveAdminViewController:ViewCourseSelectionDelegate{
    func courseViewDismissed() {
        self.viewCourseList.removeFromSuperview()
    }
    
    
}
