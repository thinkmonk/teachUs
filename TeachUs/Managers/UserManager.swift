//
//  UserManager.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
class UserManager{
    
    static let sharedUserManager = UserManager()
    
    var user:LoginUserType!
    var isAdmin = false
    var isSuperAdmin = false;
    
    func setAccessToken(_ token:String){
        UserDefaults.standard.set(token, forKey: Constants.UserDefaults.accesToken)
        UserDefaults.standard.synchronize()
    }
    
    func getAccessToken() -> String {
        guard let token = UserDefaults.standard.value(forKey: Constants.UserDefaults.accesToken) as? String else {
            return "Zmlyc3ROYW1lPURldmVuZHJhLG1pZGRsZU5hbWU9QSxsYXN0TmFtZT1GYWRuYXZpcyxyb2xsPVBST0ZFU1NPUixpZD0x"
        }
        return token
    }
    
    func setUserId(_ id:String){
        UserDefaults.standard.set(id, forKey: Constants.UserDefaults.userId)
        UserDefaults.standard.synchronize()
    }
    
    func getUserId() -> String{
        guard let userId = UserDefaults.standard.value(forKey: Constants.UserDefaults.userId) as? String else {
            return "1"
        }
        return userId
    }
}
