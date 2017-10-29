//
//  Connectivity.swift
//  TeachUs
//
//  Created by ios on 10/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
