//
//  LoadingActivityHUD.swift
//  TeachUs
//
//  Created by ios on 10/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
import UIKit

public class LoadingActivityHUD {
    static let loaderView:Loader = Loader.instanceFromNib() as! Loader
    
    class func showProgressHUD(view:UIView){
        DispatchQueue.main.async {
            loaderView.center = view.center
            view.addSubview(loaderView)
        }
        loaderView.start()
    }
    
    class func stopAnimation(object:Timer){
        loaderView.stop()
        let info:NSDictionary = object.userInfo as! NSDictionary
        if let viewBackground:UIView = info.value(forKey: "UIView") as? UIView{
            if viewBackground.subviews.contains(loaderView) {
                loaderView.removeFromSuperview()

            }
        }
    }
    
    class func hideProgressHUD(){
        loaderView.stop()
        loaderView.removeFromSuperview()
    }
}

