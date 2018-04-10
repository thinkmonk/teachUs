//
//  LeftMenuViewController.swift
//  TeachUs
//
//  Created by ios on 10/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol LeftMenuDeleagte {
    func menuItemSelected(item:Int)
}

class LeftMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var buttonProfile: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRole: UILabel!
    @IBOutlet weak var labelProfile: UILabel!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var buttonDropDown: UIButton!
    var delegate:LeftMenuDeleagte!
    var arrayDataSource:[String]! = []
    let userProfilesDropdown = DropDown()

    
//    var studentDataSource = ["Attendance", "Syllabus Status", "Feedback / Ratings", "Logout"]
    var studentDataSource = ["Attendance", "Logout"]

//    var professorDataSource = ["Attendance", "Syllabus Status", "Logs", "Logout"]
    var professorDataSource = ["Attendance", "Logout"]

    var collegeDataSource = ["Attendance","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUserDetails()
        
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        buttonDropDown.alpha=0

        let tap = UITapGestureRecognizer(target: self, action: #selector(LeftMenuViewController.showProfileDropDown))
        self.labelProfile.isUserInteractionEnabled = true
        self.labelProfile.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.buttonProfile.makeViewCircular()
        if(UserManager.sharedUserManager.appUserCollegeArray.count > 1){
            buttonDropDown.alpha=1
            setupDropdown()

        }
        
        switch UserManager.sharedUserManager.user! {
        case .Professor:
            arrayDataSource = professorDataSource
            break
        case .Student:
            arrayDataSource = studentDataSource
            break
        case .College:
            arrayDataSource = collegeDataSource
            break
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAndSetUserImage(){
        Alamofire.request(UserManager.sharedUserManager.appUserDetails.profilePicUrl!).responseImage { response in
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.buttonProfile.setImage(image, for: UIControlState.normal)
            }
        }
    }
    
    func setupDropdown(){
        self.userProfilesDropdown.anchorView = self.labelProfile
        self.userProfilesDropdown.bottomOffset = CGPoint(x: 0, y: userProfilesDropdown.height())
        self.userProfilesDropdown.width = self.labelProfile.width()
        for college in UserManager.sharedUserManager.appUserCollegeArray{
            self.userProfilesDropdown.dataSource.append(college.college_name!)
        }
        self.userProfilesDropdown.selectionAction = { [unowned self] (index, item) in
            print(item)
            UserManager.sharedUserManager.appUserCollegeDetails = UserManager.sharedUserManager.appUserCollegeArray[index]
            self.updateUserDetails()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableViewMenu.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            self.tableViewMenu.delegate?.tableView!(self.tableViewMenu, didSelectRowAt: indexPath)

        }
        DropDown.appearance().backgroundColor = UIColor.white

    }
    
    
    //WHEN USER CHANGES THE PROFILE from DropDown
    func updateUserDetails(){
        if(UserManager.sharedUserManager.appUserCollegeDetails.role_id == "3")
        {
            let collegeImage = UIImage(named: Constants.Images.collegeDefault)
            self.buttonProfile.setImage(collegeImage, for: .normal)
            self.labelName.text = "College"
            self.labelRole.text = ""
        }
        else{
            self.labelProfile.text = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_name!)"
            self.labelName.text = "\(UserManager.sharedUserManager.appUserDetails.firstName!)"
            self.labelRole.text = "\(UserManager.sharedUserManager.appUserCollegeDetails.role_name!)"
            self.getAndSetUserImage()
        }
        UserManager.sharedUserManager.setUserBasedOnRole()
    }
    
    @IBAction func showProfileDropDown(_ sender: Any) {
        self.userProfilesDropdown.show()
    }
    
    @IBAction  func showModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalViewController:EditProfilePictureViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.EditProfilePictureViewControllerId) as! EditProfilePictureViewController
        modalViewController.delegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }    
}

extension LeftMenuViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.leftMenuCell) as UITableViewCell!
        
        cell.textLabel?.text = arrayDataSource[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
        if arrayDataSource.count-1 == indexPath.row{
            UserManager.sharedUserManager.setAccessToken("")
            DatabaseManager.deleteAllEntitiesForEntityName(name: "CollegeDetails")
            DatabaseManager.deleteAllEntitiesForEntityName(name: "UserDetails")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.LoginSelectNavBarControllerId) as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = viewController

        }
        if(delegate != nil){
            delegate.menuItemSelected(item: indexPath.row)
        }
    }
}

extension LeftMenuViewController:editProfileDelegate{
    func profileEdited() {
        self.getAndSetUserImage()
    }
}
