//
//  RootViewController.swift
//  TeachUs
//
//  Created by ios on 3/14/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultBackGroundImage()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(offlineSyncComplete), name: .notificationOfflineUploadSuccess, object: nil)
        checkLogin()

        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     func checkLogin(){
        if(!UserManager.sharedUserManager.getAccessToken().isEmpty){
            if(ReachabilityManager.shared.isOfflineDataAvailable){
                ReachabilityManager.shared.networkReachbleActions()
            }
            else{
                self.getAndSaveUserToDb()
            }
        }
        else{
            self.performSegue(withIdentifier: Constants.segues.toLoginSelect, sender: self)
        }
    }
    
    
    @objc func offlineSyncComplete(){
        self.getAndSaveUserToDb()
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
