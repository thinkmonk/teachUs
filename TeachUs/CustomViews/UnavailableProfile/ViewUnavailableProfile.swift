//
//  ViewUnavailableProfile.swift
//  TeachUs
//
//  Created by ios on 6/15/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import Foundation
import UIKit

class ViewUnavailableProfile:UIView{
    
    
    @IBOutlet weak var viewBg: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewUnavailableProfile", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    @IBAction func closeView(_ sender: Any) {
        self.removeFromSuperview()
    }
}
