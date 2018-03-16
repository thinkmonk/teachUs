//
//  BaseViewController.swift
//  TeachUs
//
//  Created by ios on 10/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let color1 = UIColor(red: 116/255, green: 104/255, blue: 218/255, alpha: 1.0)
        let color2 = UIColor(red: 126/255, green: 74/255, blue: 187/255, alpha: 1.0)
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
        let color1 = UIColor(red: 116/255, green: 104/255, blue: 218/255, alpha: 1.0)
        let color2 = UIColor(red: 126/255, green: 74/255, blue: 187/255, alpha: 1.0)
        gradient.colors = [color1.cgColor, color2.cgColor]
//        UIApplication.shared.windows.last?.layer.addSublayer(gradient)
        self.view.layer.addSublayer(gradient)

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
    
    func showAlterWithTitle(_ title:String, alertMessage:String){
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func getAndSaveUserToDb(){
        let manager = NetworkHandler()
        manager.url = URLConstants.Login.userDetails
        manager.apiPost(apiName: "Get User Details", parameters: [:], completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            UserManager.sharedUserManager.saveUserDetailsToDb(response)
            NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
        }) { (error, code, message) in
            LoadingActivityHUD.hideProgressHUD()
            print(message)
        }
    }

}
