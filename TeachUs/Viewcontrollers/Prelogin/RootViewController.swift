//
//  RootViewController.swift
//  TeachUs
//
//  Created by ios on 3/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {
    private let forceUpdateManager = ForceUpdateManager.sharedForceUpdateManager
    
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
        ForceUpdateManager.sharedForceUpdateManager.checkForceUpdate { [weak self] in
            self?.checkAndShowAppUpdateDialogue()
        }
    }
    
    


    func checkAndShowAppUpdateDialogue() {
        //TEMPORARY CHECK <-------
//        if (!(self.forceUpdateObject.isForceUpdate?.caseInsensitiveCompare("yes") == .orderedSame))
        if (forceUpdateManager.forceUpdateObject.isForceUpdate?.caseInsensitiveCompare("yes") == .orderedSame && self.checkforNewVersoin())
        {
            // create the alert
            let alert = UIAlertController(title: "\(forceUpdateManager.forceUpdateObject.forceUpdateTextTitle)", message: "\(forceUpdateManager.forceUpdateObject.forceUpdateText)", preferredStyle: UIAlertController.Style.alert)
            
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
            let alert = UIAlertController(title: "New Version Available!", message: "\(forceUpdateManager.forceUpdateObject.appUpdateText)", preferredStyle: UIAlertController.Style.alert)
            
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
        let serverAppversionNumber = Int(forceUpdateManager.forceUpdateObject.version?.replacingOccurrences(of: ".", with: "") ?? "0")
        return serverAppversionNumber! > appversionNumber!
    }
    
    
    
    
    func checkLogin(){
        if(!UserManager.sharedUserManager.getAccessToken().isEmpty){
            if forceUpdateManager.checkMaintainenceFlag(){
                self.performSegue(withIdentifier: Constants.segues.rootToMaintainence, sender: self)
            }
            else{
                if(ReachabilityManager.shared.isOfflineDataAvailable){
                    ReachabilityManager.shared.networkReachbleActions()
                }
                else{
                    self.getAndSaveUserToDb(true)
                }
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
