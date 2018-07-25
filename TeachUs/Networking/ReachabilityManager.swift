//
//  ReachabilityManager.swift
//  NetworkTest
//
//  Created by Harsh on 6/7/18.
//  Copyright © 2018 Faasos. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
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
            /*
            if(UserManager.sharedUserManager.appUserCollegeDetails != nil){
                if (UserManager.sharedUserManager.appUserCollegeDetails.role_id! == AppUserRole.professor){
                    print("reachability changed in professor module")
                    viewOffline = OfflineYesNo.instanceFromNib() as? OfflineYesNo
                    if(UIApplication.shared.keyWindow != nil){
                        let window = UIApplication.shared.keyWindow!
                        viewOffline?.frame = window.frame
                        viewOffline?.buttonYes.roundedRedButton()
                        window.addSubview(viewOffline!)
                    }
                }
            }
            else{
            }
            */

            if(UserManager.sharedUserManager.user! == .Professor){
                UserManager.sharedUserManager.initOfflineUser()
                viewOffline = OfflineYesNo.instanceFromNib() as? OfflineYesNo
                if(UIApplication.shared.keyWindow != nil){
                    let window = UIApplication.shared.keyWindow!
                    viewOffline?.frame = window.frame
                    viewOffline?.buttonYes.roundedRedButton()
                    window.addSubview(viewOffline!)
                }
            }
        case .wifi:
            debugPrint("Network reachable through WiFi")
            if(viewOffline?.superview != nil){
                viewOffline?.removeFromSuperview()
                viewOffline = nil
            }
            
            let dataResponse = DatabaseManager.getEntitesForEntityName(name: "OfflineApiRequest")
            for data in dataResponse{
                let dataTransformable:OfflineApiRequest = (data as? OfflineApiRequest)!
                print(dataTransformable.attendanceParams!)
                print(dataTransformable.syllabusParams!)
            }

        case .cellular:
            debugPrint("Network reachable through Cellular Data")
        }
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
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
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }

}

