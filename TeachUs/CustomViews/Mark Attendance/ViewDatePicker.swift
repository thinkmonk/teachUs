//
//  ViewDatePicker.swift
//  TeachUs
//
//  Created by ios on 11/12/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class ViewDatePicker: UIView {

    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var viewPickerBackground: UIView!
    
    var dateString:String{
        let date = picker.date
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "dd MMMM YYYY"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate
    }
    
    var postJsonDateString:String{
        let date = picker.date
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "YYYY-MM-dd"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate

    }
    
    var timeString:String{
        let date = picker.date
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "h:mm a"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate

    }
    
    var postJsonTimeString:String{
        let date = picker.date
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "HH:mm:ss"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpPicker(type:UIDatePickerMode){
        picker.timeZone = NSTimeZone.local
        picker.datePickerMode = type
        picker.backgroundColor = UIColor.white
        self.buttonOk.roundedRedButton()
    }
    
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height()
        self.center.x = inView.centerX()
        self.center.y = inView.centerY()
        self.viewPickerBackground.makeEdgesRounded()
        inView.addSubview(self)
        
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewDatePicker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
