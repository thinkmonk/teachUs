//
//  ViewCalenderTop.swift
//  TeachUs
//
//  Created by ios on 11/17/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class ViewCalenderTop: UIView {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelNumberOfLectures: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var viewBackGround: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewCalenderTop", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    //220 is the height of calender view cell
    func decrementColorAlpha(offset: CGFloat) {
        if(offset > 220){
        self.alpha = (offset/320)
        }
        else{
            self.alpha = 0
        }
    }
    
    
    func incrementColorAlpha(offset: CGFloat) {
        self.alpha = (offset/320)
    }

    
}
