//
//  OfflineLeftMenuViewController.swift
//  TeachUs
//
//  Created by ios on 7/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class OfflineLeftMenuViewController: BaseViewController {

    @IBOutlet weak var buttonOfflineProfile: UIButton!
    @IBOutlet weak var labeOfflinelName: UILabel!
    @IBOutlet weak var labelOfflineRole: UILabel!
    @IBOutlet weak var labelOfflineProfile: UILabel!
    @IBOutlet weak var tableViewOfflneMenu: UITableView!
    @IBOutlet weak var tableViewOfflineProfile: UITableView!
    
    @IBOutlet weak var buttonDropDown: UIButton!
    var delegate:LeftMenuDeleagte!
    var arrayDataSource:[String]! = []
    var arrayCollegeDetailsDataSource:[Offline_Colleges] = []
    
    let userProfilesDropdown = DropDown()
    
    var isProfileViewOpen:Bool = false
    
    var professorDataSource = ["Attendance", "Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUserDetails()
        self.tableViewOfflineProfile.alpha  = isProfileViewOpen ? 1 : 0
        self.tableViewOfflineProfile.delegate = self
        self.tableViewOfflineProfile.dataSource = self
        tableViewOfflneMenu.delegate = self
        tableViewOfflneMenu.dataSource = self
        buttonDropDown.alpha=0
        self.arrayCollegeDetailsDataSource = UserManager.sharedUserManager.offlineAppUserData.colleges!
        let tap = UITapGestureRecognizer(target: self, action: #selector(LeftMenuViewController.showProfileDropDown))
        self.labelOfflineProfile.isUserInteractionEnabled = true
        self.labelOfflineProfile.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.buttonOfflineProfile.makeViewCircular()
        if(UserManager.sharedUserManager.appUserCollegeArray.count > 1){
            buttonDropDown.alpha=1
            setupDropdown()
        }
        self.setUpTableView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpTableView(){
        arrayDataSource = professorDataSource
        self.tableViewOfflneMenu.reloadData()
    }
    
    func setupDropdown(){
        self.userProfilesDropdown.anchorView = self.labelOfflineProfile
        self.userProfilesDropdown.bottomOffset = CGPoint(x: 0, y: userProfilesDropdown.height())
        self.userProfilesDropdown.width = self.labelOfflineProfile.width()
        for college in UserManager.sharedUserManager.appUserCollegeArray{
            self.userProfilesDropdown.dataSource.append(college.college_name!)
        }
        self.userProfilesDropdown.selectionAction = { [unowned self] (index, item) in
            print("Selected college \(item)")
            UserManager.sharedUserManager.appUserCollegeDetails = UserManager.sharedUserManager.appUserCollegeArray[index]
            self.updateUserDetails()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableViewOfflneMenu.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            self.tableViewOfflneMenu.delegate?.tableView!(self.tableViewOfflneMenu, didSelectRowAt: indexPath)
            self.setUpTableView()
        }
        DropDown.appearance().backgroundColor = UIColor.white
    }
    
    
    //WHEN USER CHANGES THE PROFILE from DropDown
    func updateUserDetails(){
        self.labelOfflineProfile.text = "Profile"
        self.labeOfflinelName.text = "\(UserManager.sharedUserManager.offlineAppUserData.profile!.f_name!) \(UserManager.sharedUserManager.offlineAppUserData.profile!.l_name!)"
        self.labelOfflineRole.text = "\(UserManager.sharedUserManager.offlineAppuserCollegeDetails.college_name!) (\(UserManager.sharedUserManager.offlineAppuserCollegeDetails.role_name!))"
    }
    
    @IBAction func showProfileDropDown(_ sender: Any) {
        if !self.isProfileViewOpen{
            self.isProfileViewOpen = true
            self.tableViewOfflneMenu.alpha  = 0
            self.tableViewOfflineProfile.alpha = 1
            //            self.tableViewProfile.reloadData()
            self.buttonDropDown.transform = self.buttonDropDown.transform.rotated(by: CGFloat.pi)
        }
        else{
            self.isProfileViewOpen = false
            self.tableViewOfflneMenu.alpha  = 1
            self.tableViewOfflineProfile.alpha = 0
            //            self.tableViewMenu.reloadData()
            self.buttonDropDown.transform = self.buttonDropDown.transform.rotated(by: -CGFloat.pi)
            
        }
        //        self.userProfilesDropdown.show()
    }
}


//MARK:- Tableview Delegates

extension OfflineLeftMenuViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableViewOfflneMenu){
            return self.arrayDataSource.count
        }
        else{
            return self.arrayCollegeDetailsDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewOfflneMenu{
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.leftMenuCell) as UITableViewCell?)!
            cell.textLabel?.textColor = .white
            cell.selectionStyle = .blue
            cell.textLabel?.text = arrayDataSource[indexPath.row]
            cell.backgroundColor = UIColor.clear
            return cell
        }
        else{
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.leftMenuCell) as UITableViewCell?)!
            let college:Offline_Colleges = arrayCollegeDetailsDataSource[indexPath.row]
            cell.textLabel?.text = "\(college.college_name!) (\(college.role_name!) )"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = .white
            cell.selectionStyle = .blue
            cell.backgroundColor = UIColor.clear
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableViewOfflneMenu{
            if arrayDataSource.count-1 == indexPath.row{
                UserManager.sharedUserManager.setAccessToken("")
                DatabaseManager.deleteAllEntitiesForEntityName(name: "CollegeDetails")
                DatabaseManager.deleteAllEntitiesForEntityName(name: "UserDetails")
                DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineUserData")
                DatabaseManager.saveDbContext()
                UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.collegeName)
                UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.roleName)
                UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.offlineCollegeName)
                UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.accesToken)
                UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.loginUserType)

                UserDefaults.standard.synchronize()
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.LoginSelectNavBarControllerId) as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }else{
                self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
                if(delegate != nil){
                    delegate.menuItemSelected(item: indexPath.row)
                }
            }
        }
        else{
            self.showProfileDropDown(self)
            UserManager.sharedUserManager.offlineAppuserCollegeDetails = UserManager.sharedUserManager.offlineAppUserData.colleges![indexPath.row]
            UserDefaults.standard.set(UserManager.sharedUserManager.offlineAppuserCollegeDetails.college_name!, forKey: Constants.UserDefaults.offlineCollegeName)
            UserDefaults.standard.synchronize()
            self.updateUserDetails()
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableViewOfflneMenu.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            self.tableViewOfflneMenu.delegate?.tableView!(self.tableViewOfflneMenu, didSelectRowAt: indexPath)
            self.setUpTableView()
        }
    }

    

}
