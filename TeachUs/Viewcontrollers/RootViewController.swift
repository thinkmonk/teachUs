//
//  RootViewController.swift
//  TeachUs
//
//  Created by ios on 3/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    var forceUpdateObject:DeviceUpdate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultBackGroundImage()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(offlineSyncComplete), name: .notificationOfflineUploadSuccess, object: nil)
        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkForceUpdate()
    }
    
    func checkForceUpdate(){
        
        let manager = NetworkHandler()
        manager.url = URLConstants.Login.forceUpdateCheck
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiGetWithDataResponse(apiName: "Check Force update for app", completionHandler: { (response, code) in
            LoadingActivityHUD.hideProgressHUD()
            if(code == 200){
                do{
                    if let datareposne = response as? Data{
                        let decoder = JSONDecoder()
                        let forceUpdate = try decoder.decode(ForceUpdate.self, from: datareposne)
                        self.forceUpdateObject = forceUpdate.deviceUpdate?.filter({$0.osType?.caseInsensitiveCompare("IOS") == .orderedSame}).first
                        self.checkAndShowAppUpdateDialogue()
                    }else{
                        print("Failed to convert data")
                    }
                }
                catch let error{
                    print("err", error)
                }
            }
            else{
                print("Error in fetching data")
            }
        }) { (error, code, errorMessage) in
            LoadingActivityHUD.hideProgressHUD()
        }
    }


    func checkAndShowAppUpdateDialogue() {
        //TEMPORARY CHECK <-------
//        if (!(self.forceUpdateObject.isForceUpdate?.caseInsensitiveCompare("yes") == .orderedSame))
        if (self.forceUpdateObject.isForceUpdate?.caseInsensitiveCompare("yes") == .orderedSame && self.checkforNewVersoin())
        {
            // create the alert
            let alert = UIAlertController(title: "\(self.forceUpdateObject.forceUpdateTextTitle)", message: "\(self.forceUpdateObject.forceUpdateText)", preferredStyle: UIAlertController.Style.alert)
            
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
        }else if (self.checkforNewVersoin()) {
            let alert = UIAlertController(title: "New Version Available!", message: "\(self.forceUpdateObject.appUpdateText)", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction((UIAlertAction(title: "Go to AppStore", style: .default, handler: { (action) in
                if let url = URL(string: URLConstants.TeachUsAppStoreLink.storeLink) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {action in
                self.checkLogin()
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            self.checkLogin()
        }
    }
    
    func checkforNewVersoin() -> Bool{
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let appversionNumber = Int(appVersion?.replacingOccurrences(of: ".", with: "") ?? "0")
        let serverAppversionNumber = Int(self.forceUpdateObject.version?.replacingOccurrences(of: ".", with: "") ?? "0")
        return serverAppversionNumber! > appversionNumber!
    }
    
     func checkLogin(){
        if(!UserManager.sharedUserManager.getAccessToken().isEmpty){
            if(ReachabilityManager.shared.isOfflineDataAvailable){
                ReachabilityManager.shared.networkReachbleActions()
            }
            else{
                self.getAndSaveUserToDb(true)
            }
        }
        else{
            self.performSegue(withIdentifier: Constants.segues.toLoginSelect, sender: self)
        }
    }
    
    
    @objc func offlineSyncComplete(){
        self.getAndSaveUserToDb(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
