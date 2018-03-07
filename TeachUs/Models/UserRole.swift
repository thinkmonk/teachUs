//
//  UserRole.swift
//  TeachUs
//
//  Created by ios on 3/8/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import Foundation
import ObjectMapper
class  UserRole: Mappable {
    var roleId:String = ""
    var roleName:String = ""
    var roleCode:String = ""
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        self.roleId <- map["role_id"]
        self.roleName <- map["role_name"]
        self.roleCode <- map["role_code"]
    }
}
