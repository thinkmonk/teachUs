//
//  CollegeLogin.swift
//  TeachUs
//
//  Created by ios on 10/30/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
protocol CollegeLoginDelegate {
    func sendCollegeOtp(mobileNumber:String)
    func verifyCollegeOtp()
}

class CollegeLogin: UIView {
    
    @IBOutlet weak var viewsendOtp: UIView!
    
    @IBOutlet weak var viewMobileNumberTf: UIView!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var buttonSendOtp: UIButton!
    
    @IBOutlet weak var viewVerifyOtp: UIView!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var stackViewEnterOTp: UIStackView!
    @IBOutlet weak var textFieldOtp: UITextField!
    @IBOutlet weak var buttonVerifyOtp: UIButton!
    @IBOutlet weak var labelOtpTimeLeft: UILabel!
    
    var disposeBag: DisposeBag! = DisposeBag()
    var delegate:CollegeLoginDelegate!
    var userType:LoginUserType!
    let picker = UIPickerView()
    var mobileNumber = ""
    
    func setUpReactive()
    {
        let otpValid = textFieldOtp.rx.text.orEmpty
            .map { $0.count > 0 }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        
        otpValid
            .bind(to: buttonVerifyOtp.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let mobileNumberValid = textFieldMobileNumber.rx.text.orEmpty
            .map { $0.count == 10 }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        
        mobileNumberValid.subscribe(onNext:{ isValid in
            if(isValid){
                self.buttonSendOtp.alpha = 1;
            }
            else{
                self.buttonSendOtp.alpha = 0;
            }
        }).disposed(by: disposeBag)
    }
    
    func setUpView(){
        self.viewMobileNumberTf.makeEdgesRoundedWith(radius: self.viewMobileNumberTf.height()/2)
        self.textFieldOtp.makeEdgesRoundedWith(radius: self.textFieldOtp.height()/2)
        
        self.buttonSendOtp.makeEdgesRoundedWith(radius: self.buttonSendOtp.height()/2)
        self.buttonSendOtp.roundedBlueButton()
        
        self.buttonVerifyOtp.makeEdgesRoundedWith(radius: self.buttonVerifyOtp.height()/2)
        self.buttonVerifyOtp.roundedRedButton()
        self.viewsendOtp.alpha = 1
        self.viewVerifyOtp.alpha = 0
        self.labelOtpTimeLeft.makeViewCircular()
        self.labelOtpTimeLeft.isHidden = true

    }
    
    
    @IBAction func sendOtp(_ sender: UIButton) {
        self.mobileNumber = self.textFieldMobileNumber.text!
        if(delegate != nil){
            self.delegate.sendCollegeOtp(mobileNumber: self.mobileNumber)
        }
    }
    
    func setUpVerifyOtpView(){
        self.labelMobileNumber.text = self.mobileNumber
        self.viewVerifyOtp.alpha = 1
    }
    
    @IBAction func verifyOtp(_ sender: Any) {
        if(self.delegate != nil){
            delegate.verifyCollegeOtp()
        }
    }
    
    func showView(inView:UIView, yPosition:CGFloat){
        self.alpha = 0.0
        self.frame.size.width = inView.width() * 0.9
        self.frame.origin.y = yPosition
        self.center.x = inView.centerX()
        self.setUpReactive()
        inView.addSubview(self)
        
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: { (result) in
            print("completion result is \(result)")
        })
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CollegeLogin", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
