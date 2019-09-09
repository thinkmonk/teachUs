//
//  EventManager.swift
//  TeachUs
//
//  Created by ios on 9/9/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
class EventManager{
    static let shared = EventManager()
    
    final func addEvent(params:[String:Any]?,
                        completionHandler: @escaping (_ successFlag:Bool,_ message:String?) -> Void){
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.addNewEvent
        
        manager.apiPost(apiName: " Add new Event", parameters:params, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                completionHandler(true,message)
            }
        }) { (error, code, message) in
            completionHandler(false,message)
        }

    }
    
    final func editEvent(params:[String:Any]?,
                         completionHandler: ((_ successFlag:Bool) -> Void)?){
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.editEventDetails
        manager.apiPost(apiName: " Edit Event", parameters:params, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
               // let message:String = response["message"] as! String
                completionHandler?(true)
            }
        }) { (error, code, message) in
            completionHandler?(false)
        }
        
    }
}
