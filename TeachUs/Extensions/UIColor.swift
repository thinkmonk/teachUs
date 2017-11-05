//
//  UIColor.swift
//  TeachUs
//
//  Created by ios on 11/5/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation
extension UIColor{
    
    class func rgbColor(_ red:CGFloat, _ green: CGFloat, _ blue:CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
