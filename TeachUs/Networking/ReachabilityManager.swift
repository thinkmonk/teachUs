//
//  ReachabilityManager.swift
//  NetworkTest
//
//  Created by Harsh on 6/7/18.
//  Copyright © 2018 Faasos. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    var viewControllersToBeIgnored:[UIViewController] = [
        StudentsListViewController(),
        MarkCompletedPortionViewController(),
        OfflineStudentListViewController(),
        OfflineMarkCompletedPortionViewController()
    ]
    
    var isMonitoringPaused:Bool = false
    
    
    var isOfflineDataAvailable:Bool{
        //        DatabaseManager.deleteAllEntitiesForEntityName(name: "OfflineApiRequest")
        //        DatabaseManager.saveDbContext()
        let dataResponse = DatabaseManager.getEntitesForEntityName(name: "OfflineApiRequest")
        if dataResponse.count > 0{
            return true
        }else{
            return false
        }
    }
    
    static  let shared = ReachabilityManager()  // 2. Shared instance
    var viewOffline:OfflineYesNo?
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.Connection = .none
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
            let userData = DatabaseManager.getEntitesForEntityName(name: Constants.DatabaseEntities.OfflineUserData)
            if(UserManager.sharedUserManager.user != nil && userData.count > 0){
                if(UserManager.sharedUserManager.user! == .Professor && UserManager.sharedUserManager.isUserInOfflineMode == false){
                    UserManager.sharedUserManager.initOfflineUser()
                    viewOffline = OfflineYesNo.instanceFromNib() as? OfflineYesNo
                    if(UIApplication.shared.keyWindow != nil){
                        let window = UIApplication.shared.keyWindow!
                        viewOffline?.frame = window.frame
                        viewOffline?.buttonYes.roundedRedButton()
                        window.addSubview(viewOffline!)
                    }
                }
                
            }
        case .wifi:
            #if DEBUG
                debugPrint("Network reachable through WiFi")
            #endif
            if(self.isOfflineDataAvailable){
                self.networkReachbleActions()
            }
            else{
                if(UserManager.sharedUserManager.isUserInOfflineMode && UserManager.sharedUserManager.user != nil){
                    NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
                }
            }
            
        case .cellular:
            #if DEBUG
            debugPrint("Network reachable through Cellular Data")
            #endif
            if(self.isOfflineDataAvailable){
                self.networkReachbleActions()
            }else{
                if(UserManager.sharedUserManager.isUserInOfflineMode){
                    NotificationCenter.default.post(name: .notificationLoginSuccess, object: nil)
                    
                }
            }
        }
    }
    
    func resumeMomitoring(){
        print("Monitoring resumed")
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        let topVC = GlobalFunction.topViewController()
        if(!GlobalFunction.checkIfViewcontrollerExitsInArray(topVC!, viewControllersToBeIgnored)){
            print("Monitoring started")
            NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.reachabilityChanged),
                                                   name: Notification.Name.reachabilityChanged,
                                                   object: reachability)
            do{
                try reachability.startNotifier()
            } catch {
                debugPrint("Could not start reachability notifier")
            }
        }
    }
    
    func networkReachbleActions(){
        if(viewOffline?.superview != nil){
            viewOffline?.removeFromSuperview()
            viewOffline = nil
        }
        if(UserManager.sharedUserManager.user != nil){
            let dataResponse = DatabaseManager.getEntitesForEntityName(name: "OfflineApiRequest")
            if dataResponse.count > 0{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller:UploadOfflineDataViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.UploadOfflineDataViewControllerId) as! UploadOfflineDataViewController
                UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
            }
            else{
                NotificationCenter.default.post(name: .notificationOfflineUploadSuccess, object: nil)
            }
        }
        /*
         for data in dataResponse{
         let dataTransformable:OfflineApiRequest = (data as? OfflineApiRequest)!
         print(dataTransformable.attendanceParams!)
         print(dataTransformable.syllabusParams!)
         }
         */
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    func pauseMonitoring(){
        print("Monitoring paused")
        reachability.stopNotifier()
        self.isMonitoringPaused = true
    }
}
