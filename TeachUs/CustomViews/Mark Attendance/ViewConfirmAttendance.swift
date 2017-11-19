//
//  ViewConfirmAttendance.swift
//  TeachUs
//
//  Created by ios on 11/17/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit


protocol ViewConfirmAttendanceDelegate {
    func confirmAttendance()
}

class ViewConfirmAttendance: UIView {

    @IBOutlet weak var labelStudentCount: UILabel!
    @IBOutlet weak var buttonRecheck: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    var delegate:ViewConfirmAttendanceDelegate!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height()
        self.center.x = inView.centerX()
        self.center.y = inView.centerY()
        self.buttonConfirm.roundedBlueButton()
        self.buttonRecheck.roundedRedButton()
        self.viewBackground.makeEdgesRounded()
        inView.addSubview(self)
        
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewConfirmAttendance", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    @IBAction func recheckClicked(_ sender: Any) {
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
    @IBAction func confirmAttendance(_ sender: Any) {
        
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (completed) in
            if(self.delegate != nil){
                self.transform = CGAffineTransform.identity
                self.removeFromSuperview()
                self.delegate.confirmAttendance()
            }
        }
        
        

    }
    
}
