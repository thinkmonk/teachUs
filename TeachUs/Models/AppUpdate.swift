//
//  AppUpdate.swift
//  TeachUs
//
//  Created by ios on 3/29/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 "device_update": [
 {
 "os_type": "IOS",
 "version": "12.0.1",
 "is_force_update": "yes"
 },
 {
 "os_type": "android",
 "version": "12.8.1",
 "is_force_update": "yes"
 }
 ]
 */


class AppUpdateData:Mappable
{
    
    var osType:String?
    var isforceUpdateTempText:String!
    var isforceUpdate:Bool!
    var appServerVersion:String?
    var appUpdateText:String = "Latest version is waiting for you. Please update the application now!"
    var forceUpdateText:String = "All set for the newest experience of your own App! Please update the application now!"
    var forceUpdateTextTitle:String = "Heads up!"

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.osType <- map["os_type"]
        self.appServerVersion <- map["version"]
        self.isforceUpdateTempText <- map["is_force_update"]
        self.isforceUpdate = self.isforceUpdateTempText.elementsEqual("yes") ? true : false
    }
    
   
}

