//
//  LeftMenuViewController.swift
//  TeachUs
//
//  Created by ios on 10/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

protocol LeftMenuDeleagte {
    func menuItemSelected(item:Int)
}

class LeftMenuViewController: UIViewController {
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRole: UILabel!
    @IBOutlet weak var labelProfile: UILabel!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var buttonDropDown: UIButton!
    var delegate:LeftMenuDeleagte!
    var arrayDataSource:[String]!
    
    
    var studentDataSource = ["Attendance", "Syllabus Status", "Feedback / Ratings", "Logout"]
    var professorDataSource = ["Attendance", "Syllabus Status", "Logs", "Logout"]
    var collegeDataSource = ["Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        buttonDropDown.alpha=0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserManager.sharedUserManager.userProfilesArray.count > 1){
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
    
    
    func setupDropdown(){
        self.arrayDataSource.removeAll()
        
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
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.LoginSelectNavBarControllerId) as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = viewController

        }
        if(delegate != nil){
            delegate.menuItemSelected(item: indexPath.row)
        }
    }
}
