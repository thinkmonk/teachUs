//
//  ViewRatingInfo.swift
//  TeachUs
//
//  Created by ios on 11/25/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class ViewRatingInfo: UIView {
    

    @IBOutlet weak var viewDetailsBackGround: UIView!
    @IBOutlet weak var labelRatingDetails: UILabel!
    @IBOutlet weak var buttonOk: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewRatingInfo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height()
        self.center.x = inView.centerX()
        self.center.y = inView.centerY()
        self.viewDetailsBackGround.makeTableCellEdgesRounded()
        inView.addSubview(self)
        
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
    }
    @IBAction func okClicked(_ sender: Any) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (completed) in
            if(completed){
                self.transform = CGAffineTransform.identity
                self.removeFromSuperview()
            }
        }
    }
    
}
