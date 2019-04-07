//
//  ViewController.swift
//  TeachUs
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper

enum LoginUserType {
    case Student
    case Professor
    case College
}

class LoginSelectViewController: BaseViewController {
    @IBOutlet weak var viewButtonStack: UIStackView!
    var arrayUserRoles:[UserRole] = []
    var userType:LoginUserType!
    var roleStudent:UserRole!
    var roleProfessor:UserRole!
    var roleCollege:UserRole!
    var appUpdateData:AppUpdateData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultBackGroundImage()
        self.navigationController?.navigationBar.isHidden = false

        self.viewButtonStack.alpha = 0
        self.getRoleList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientToNavBar()
        self.addColorToNavBarText(color: UIColor.white)
    }
    
    func getRoleList(){
        let manager = NetworkHandler()
        //http://zilliotech.com/api/teachus/role
        manager.url = URLConstants.Login.role
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGet(apiName: "Get Role for all user", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            
            /*
            let appUpdateData:[Any] = response["device_update"] as! [Any]
            for update in appUpdateData{
                let tempUpdate :AppUpdateData = Mapper<AppUpdateData>().map(JSONObject: update)!
                if tempUpdate.osType == "IOS"
                {
                    self.appUpdateData = tempUpdate
                }
                self.checkAndShowAppUpdateDialogue()
            }
            */
            let userRoleDict:[Any] = response["roles"] as! [Any]
            for user in userRoleDict{
                let userRoleDict:[String:Any] = user as! [String:Any]
                let userRoleString:String = userRoleDict["role_name"] as! String
                switch userRoleString{
                case "Student":
                    self.roleStudent = Mapper<UserRole>().map(JSONObject: user)!
                    break
                case "Lecturer":
                    self.roleProfessor = Mapper<UserRole>().map(JSONObject: user)!
                    break
                case "College":
                    self.roleCollege = Mapper<UserRole>().map(JSONObject: user)!
                    break

                default:
                    break
                }
            }
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.viewButtonStack.alpha = 1
            })
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == Constants.CustomErrorCodes.noInternet){
                
                self.showErrorAlert(.NoInternet, retry: { (retry) in
                    if(retry){
                        self.getRoleList()
                    }
                })
            }
            print(errorMessage)
        }
    }

    @IBAction func loginStudent(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.Student)
        UserManager.sharedUserManager.userRole = roleStudent
        self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
    }
    
    @IBAction func loginProfessor(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.Professor)
        UserManager.sharedUserManager.userRole = roleProfessor
        self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
    }

    @IBAction func loginCollege(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.College)
        UserManager.sharedUserManager.userRole = roleCollege
        self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
    }

    func checkAndShowAppUpdateDialogue() {
        if !(self.appUpdateData.isforceUpdate)
        {
            // create the alert
            let alert = UIAlertController(title: "\(self.appUpdateData.forceUpdateTextTitle)", message: "\(self.appUpdateData.forceUpdateText)", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction((UIAlertAction(title: "Go to AppStore", style: .default, handler: { (action) in
                if let url = URL(string: URLConstants.TeachUsAppStoreLink.storeLink) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })))
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "New Version Available!", message: "\(self.appUpdateData.appUpdateText)", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction((UIAlertAction(title: "Go to AppStore", style: .default, handler: { (action) in
                if let url = URL(string: URLConstants.TeachUsAppStoreLink.storeLink) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toLoginView{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            

        }
    }
}

