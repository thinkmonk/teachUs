//
//  AttendanceReport.swift
//  TeachUs
//
//  Created by ios on 4/6/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

protocol AttendanceReportProtocol {
    func sendReport(type:ReportType)
    func dissmissView()
}

enum ReportType:String {
    case smsStudents
    case mailStudents
}

class AttendanceReport: UIView {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSuccessMessage: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var imageSuccess: UIImageView!
    @IBOutlet weak var titleViewBg: UIView!
    @IBOutlet weak var reportViewBg: UIView!
    @IBOutlet weak var buttonDissmiss: UIButton!
    var delegate : AttendanceReportProtocol!
    var collegeClass:CollegeAttendanceList!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK:- Outlet mthods
    
    
    @IBAction func dismissView(_ sender: Any) {
        if(delegate != nil){
            delegate.dissmissView()
        }
    }
    
    
    //MARL:- class methods
    func setUpText(type:ReportType){
        switch type{
        case .mailStudents:
            self.labelSuccessMessage.text = "SMS successfully sent"
            self.buttonSubmit.setTitle("Mail Students", for: .normal)
            self.buttonSubmit.removeTarget(nil, action: nil, for: .allEvents)
            self.buttonSubmit.addTarget(self, action:#selector(AttendanceReport.mailReports), for: .touchUpInside)
        case .smsStudents:
            self.labelSuccessMessage.text = "Report successfully mailed"
            self.buttonSubmit.setTitle("SMS Students", for: .normal)
            self.buttonSubmit.removeTarget(nil, action: nil, for: .allEvents)
            self.buttonSubmit.addTarget(self, action:#selector(AttendanceReport.smslReports), for: .touchUpInside)
        }
    }
    
    
    
    //MARK:- Ciustom mthods
    @objc func mailReports(){
        if(self.delegate != nil){
            delegate.sendReport(type: .mailStudents)
        }
    }
    
    @objc func smslReports(){
        if(self.delegate != nil){
            delegate.sendReport(type: .smsStudents)
        }
    }
    
    
func setUpUI() {
//    self.titleViewBg.makeBottomEdgesRounded()
    self.reportViewBg.makeEdgesRounded()
    self.buttonSubmit.roundedPurpleButton()
    self.labelTitle.text = " \(self.collegeClass.courseName) Report"
//    self.buttonDissmiss.alpha = 0
}
    
    
func showView(inView:UIView){
    self.alpha = 0.0
    self.frame = inView.frame
    self.center.x = inView.centerX()
    inView.addSubview(self)
    //display the view
    transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    self.setUpText(type: .smsStudents)
    UIView.animate(withDuration: 0.3, animations: {
        self.alpha = 1.0
        self.transform = CGAffineTransform.identity
    }, completion: { (result) in
        print("completion result is \(result)")
    })
}

    func animationForSmsSuccess(message:String){
        self.imageSuccess.alpha = 0
        self.labelSuccessMessage.alpha = 0
        self.buttonSubmit.alpha = 0
        self.setUpText(type: .mailStudents)
        UIView.animate(withDuration: 0.2, animations: {
            self.imageSuccess.alpha = 1
        }) { (completed) in
            if completed {
                UIView.animate(withDuration: 0.2, animations: {
                    self.labelSuccessMessage.alpha = 1
                }, completion: { (completed) in
                    if completed {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.buttonSubmit.alpha = 1
                        })
                    }
                })
            }
        }
    }
    
    func animationFotMailSuccess(message:String){
        self.imageSuccess.alpha = 0
        self.labelSuccessMessage.alpha = 0
        self.buttonSubmit.alpha = 0
        self.labelSuccessMessage.text = message
        UIView.animate(withDuration: 0.2, animations: {
            self.imageSuccess.alpha = 1
        }) { (completed) in
            if completed {
                UIView.animate(withDuration: 0.2, animations: {
                    self.labelSuccessMessage.alpha = 1
                })
            }
        }
    }


func hideView(){
    self.alpha = 1.0
    UIView.animate(withDuration: 0.3, animations: {
        self.alpha = 0.0
        self.removeFromSuperview()
    }, completion:nil)
}
    
    func showDissmissButton(){
        UIView.animate(withDuration: 0.3) {
            self.buttonDissmiss.alpha = 1
        }
    }


class func instanceFromNib() -> UIView {
    return UINib(nibName: "AttendanceReport", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
}

}


