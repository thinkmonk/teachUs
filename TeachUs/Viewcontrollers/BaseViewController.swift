//
//  BaseViewController.swift
//  TeachUs
//
//  Created by ios on 10/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(BaseViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender:AnyObject) {
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var navBarHeight:CGFloat {
        return self.navigationController!.navigationBar.frame.height
    }
    
    var statusBarHeight:CGFloat{
        return UIApplication.shared.statusBarFrame.height
    }
    
    func addGradientToNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.statusBarFrame.width, height: statusBarHeight + navBarHeight)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        //        let color1 = UIColor(red: 116/255, green: 104/255, blue: 218/255, alpha: 1.0)
        //      let color2 = UIColor(red: 126/255, green: 74/255, blue: 187/255, alpha: 1.0)
        let color1 = UIColor(red: 18/255, green: 63/255, blue: 148/255, alpha: 1.0)
        let color2 = UIColor(red: 8/255, green: 47/255, blue: 136/255, alpha: 1.0)
        
        gradient.colors = [color1.cgColor, color2.cgColor]
        UIApplication.shared.windows.last?.layer.addSublayer(gradient)
        self.view.layer.addSublayer(gradient)
    }
    
    
    func addGradientToNavBarWithMenu(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0,
                                y: 0,
                                width: UIApplication.shared.statusBarFrame.width,
                                height: statusBarHeight + navBarHeight + CGFloat(Constants.NumberConstants.homeTabBarHeight))
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        //  let color1 = UIColor(red: 116/255, green: 104/255, blue: 218/255, alpha: 1.0)
        //let color2 = UIColor(red: 126/255, green: 74/255, blue: 187/255, alpha: 1.0)
        
        let color1 = UIColor(red: 18/255, green: 63/255, blue: 148/255, alpha: 1.0)
        let color2 = UIColor(red: 8/255, green: 47/255, blue: 136/255, alpha: 1.0)
        
        gradient.colors = [color1.cgColor, color2.cgColor]
        //        UIApplication.shared.windows.last?.layer.addSublayer(gradient)
        //        self.view.layer.addSublayer(gradient)
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func addColorToNavBarText(color: UIColor){
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
    }
    
    func addDefaultBackGroundImage(){
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        
    }
    
    func showAlterWithTitle(_ title:String?, alertMessage:String){
        let alertTitle = title != nil ? title : nil
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if (rootViewController!.isViewLoaded && (rootViewController!.view.window != nil)) {
            rootViewController?.present(alert, animated: true, completion: nil)
        }
        else{
            self.present(alert, animated: true, completion: nil)
        }
    }
    typealias TryAgainCompletionBlock = () -> Void
    var tryAgainCallBack: TryAgainCompletionBlock = { }
    
    enum ErrorType{
        case NoInternet
        case ServerCallFailed
    }
    
    func showErrorAlert(_ errorType:ErrorType, retry: @escaping (_ retry:Bool) -> Void){
        var title:String = ""
        var description:String = ""
        
        switch errorType {
        case .NoInternet:
            title = "No Internet"
            description = "Please check your internet connection"
            
        case .ServerCallFailed:
            title = "Error"
            description = "Failed to conect to server, Please Retry"
        }
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.default) {
            UIAlertAction in
            retry(true)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getAndSaveUserToDb(_ isLoginFlow:Bool){
        let manager = NetworkHandler()
        manager.url = URLConstants.Login.userDetails
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiPost(apiName: "Get User Details", parameters: [:], completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            UserManager.sharedUserManager.saveUserDetailsToDb(response)
            UserManager.sharedUserManager.initLoggedInUser()
            if(UserManager.sharedUserManager.appUserCollegeDetails.role_id == AppUserRole.professor){//check if logged-in user is a professor and fetch offline data
                self.getOfflineData()
            }
            else if isLoginFlow {
                NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
            }
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    //For college Role
    func getAndSaveUserCollegeDetails(){
        let manager = NetworkHandler()
        manager.url = URLConstants.Login.userDetails
        let parameters:[String:Any] =
            [
                "role_id":"\(UserManager.sharedUserManager.userRole.roleId)",
                "contact":"\(UserManager.sharedUserManager.getUserMobileNumber())",
        ]
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiPost(apiName: "Get User Details", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            UserManager.sharedUserManager.saveUserDetailsToDb(response)
            NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
    
    //MARK:- offline
    func getOfflineData(){
        let manager = NetworkHandler()
        manager.url = URLConstants.OfflineURL.getOfflineData
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let parameters:[String:Any] = ["offline_count":"-1"]
        manager.apiPost(apiName: "Get User Details for offline mode", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                UserManager.sharedUserManager.saveOfflineDataToDb(offlineData: response)
                NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
            }
            else{
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: "\(message)")
                NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
            }
            
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }
    
}
