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
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    class func checkIfFileExisits(fileUrl:String) -> String?{
        if let url = URL(string: fileUrl) {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let filePathURL = NSURL(fileURLWithPath: path)
            if let pathComponent = filePathURL.appendingPathComponent(url.lastPathComponent) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    return filePath
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        return nil
    }
    
    class func downloadFileAndSaveToDisk(fileUrl:String){
        if let url = URL(string: fileUrl) {
            URLSession.shared.downloadTask(with: url) { location, response, error in
                guard let location = location else {
                    print("download error:", error ?? "")
                    return
                }
                // move the downloaded file from the temporary location url to your app documents directory
                do {
                    try FileManager.default.moveItem(at: location, to: self.documents.appendingPathComponent(response?.suggestedFilename ?? url.lastPathComponent))
                } catch {
                    print(error.localizedDescription)
                }
                }.resume()
        }
    }
    
    class func checkIfFileExisits(fileUrl:String, name:String) -> String?{
        if let url = URL(string: fileUrl) {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let filePathURL = NSURL(fileURLWithPath: path)
            if let pathComponent = filePathURL.appendingPathComponent(name) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    return filePath
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        return nil
    }
    
    
    
    class func downloadFileAndSaveToDisk(fileUrl:String,
                                         customName:String,
                                         completion:@escaping (_ success:Bool) -> Void){
        if let url = URL(string: fileUrl) {
            URLSession.shared.downloadTask(with: url) { location, response, error in
                guard let location = location else {
                    print("download error:", error ?? "")
                    completion(false)
                    return
                }
                // move the downloaded file from the temporary location url to your app documents directory
                do {
                    try FileManager.default.moveItem(at: location, to: self.documents.appendingPathComponent(customName))
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(true)
                }
                }.resume()
        }
    }


}

