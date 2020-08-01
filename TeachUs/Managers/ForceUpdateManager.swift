//
//  ForceUpdateManager.swift
//  TeachUs
//
//  Created by iOS on 01/08/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class ForceUpdateManager{
    static var sharedForceUpdateManager = ForceUpdateManager()
    private(set) var forceUpdateObject:DeviceUpdate!
    
    func checkForceUpdate(completion: @escaping () -> Void){
        
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
                        completion()
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
    
    func checkMaintainenceFlag() -> Bool
    {
//        return false
        switch UserManager.sharedUserManager.user {
        case .student:
            return self.forceUpdateObject.studentMaintenance?.boolValue() ?? false
        case .college:
            return self.forceUpdateObject.collegeMaintenance?.boolValue() ?? false
        case .parents:
            return self.forceUpdateObject.parentMaintenance?.boolValue() ?? false
        case .professor:
            return self.forceUpdateObject.professorMaintenance?.boolValue() ?? false
            
        default: return false
        }
    }
}
