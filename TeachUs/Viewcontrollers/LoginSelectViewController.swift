//
//  ViewController.swift
//  TeachUs
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

enum LoginUserType {
    case Student
    case Professor
    case College
}

class LoginSelectViewController: BaseViewController {
    @IBOutlet weak var viewButtonStack: UIStackView!
    
    var userType:LoginUserType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultBackGroundImage()
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
            
            UIView.animate(withDuration: 0.5, animations: {
                self.viewButtonStack.alpha = 1
            })
            
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
            print(errorMessage)
        }
    }

    @IBAction func loginStudent(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.Student)
        self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
    }
    
    @IBAction func loginProfessor(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.Professor)
        self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
    }

    @IBAction func loginCollege(_ sender: Any) {
        UserManager.sharedUserManager.setLoginUserType(.College)
        self.performSegue(withIdentifier: Constants.segues.toLoginView, sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toLoginView{
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
//            if let destinationVC:LoginViewController = segue.destination as? LoginViewController {
//                destinationVC.usertype = self.userType
//            }
            

        }
    }
}

