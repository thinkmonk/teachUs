//
//  ForceUpdate.swift
//  TeachUs
//
//  Created by ios on 3/30/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
struct ForceUpdate: Codable {
    let deviceUpdate: [DeviceUpdate]?
    
    enum CodingKeys: String, CodingKey {
        case deviceUpdate = "device_update"
    }
}

struct DeviceUpdate: Codable {
    let osType, version, isForceUpdate: String?
    var appUpdateText:String = "Latest version is waiting for you. Please update the application now!"
    var forceUpdateText:String = "All set for the newest experience of your own App! Please update the application now!"
    var forceUpdateTextTitle:String = "Heads up!"

    enum CodingKeys: String, CodingKey {
        case osType = "os_type"
        case version
        case isForceUpdate = "is_force_update"
    }
}
