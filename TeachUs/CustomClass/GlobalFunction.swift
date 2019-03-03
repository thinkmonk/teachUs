//
//  GlobalFunction.swift
//  TeachUs
//
//  Created by ios on 1/13/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
class GlobalFunction{
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let controller = controller as? MFSideMenuContainerViewController{
            return self.topViewController(controller:controller.centerViewController as? UIViewController)
        }
        return controller
    }
    
    class func checkIfViewcontrollerExitsInArray(_ viewConntroller:UIViewController,_ viewcontrollerArray:[UIViewController]) -> Bool{
        for vc in viewcontrollerArray{
            if (vc.isKind(of: viewConntroller.classForCoder)){
                return true
            }
        }
        return false
    }
    
    class func minutesAndSecsFrom(seconds: Int, completion: @escaping (_ minutes: Int, _ seconds: Int)->()) {
        
        completion((seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    class func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "\(seconds)" : "\(seconds)"
    }
}
