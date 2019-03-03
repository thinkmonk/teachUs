//
//  OtpView.swift
//  TeachUs
//
//  Created by ios on 10/29/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol OtpDelegate {
    func sendOtp()
    func verifyOtp()
}

class OtpView: UIView {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRecordAvailable: UILabel!
    @IBOutlet weak var buttonSendOtp: UIButton!
    @IBOutlet weak var labelOtpMobileNUmber: UILabel!
    @IBOutlet weak var viewOtp: UIStackView!
    @IBOutlet weak var textFieldOtp: UITextField!
    @IBOutlet weak var buttonVerifyOtp: UIButton!
    @IBOutlet weak var labelOtpTimeLeft: UILabel!
    
    
    var disposeBag: DisposeBag! = DisposeBag()
    var delegate:OtpDelegate!
    var userType:LoginUserType!
    var OtpText = Variable<String>("")
    var username: String = "User"
    var mobileNumber:String = "9876543210"
//
//    let otpValid: Observable<Bool> = userNameText.rx_text
//        .map{ text -> Bool in
//            text.characters.count >= requiredUserNameLength
//        }
//        .shareReplay(1)
    
    
    func setUpReactive()
    {
        let otpValid = textFieldOtp.rx.text.orEmpty
            .map { $0.characters.count > 0 }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        
        otpValid
            .bind(to: buttonVerifyOtp.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    func setUpSendOtpView(){
        switch UserManager.sharedUserManager.user!
        {
        case .Student:
            self.labelTitle.text = "STUDENT"
            break
            
        case .Professor:
            self.labelTitle.text = "LECTURER"
            break
        case .College:
            break
        }
        self.buttonSendOtp.isHidden = true
        self.labelOtpTimeLeft.backgroundColor = UIColor.lightGray
        self.labelRecordAvailable.text = "Record of \(UserManager.sharedUserManager.userName) is available"
        self.buttonSendOtp.roundedBlueButton()
        self.buttonVerifyOtp.roundedRedButton()
        self.textFieldOtp.makeEdgesRoundedWith(radius: self.textFieldOtp.height()/2)
        self.labelOtpMobileNUmber.alpha = 0
        self.labelOtpTimeLeft.makeViewCircular()
        self.viewOtp.alpha = 0
    }
    
    func showRecordAvailableView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width() * 0.95
        self.frame.origin.y = inView.height()*0.30
        self.center.x = inView.centerX()
        self.setUpReactive()   //SET UP REACTIVE
        inView.addSubview(self)
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion:  { (result) in
            print("completion result is \(result)")
            self.labelRecordAvailable.preferredMaxLayoutWidth = self.width() - 40
        })
    }
    
    func setUpOtpView(){
        var editedMobileNumber = UserManager.sharedUserManager.getUserMobileNumber()
        if(editedMobileNumber.characters.count >= 10){
            let start = editedMobileNumber.index(editedMobileNumber.startIndex, offsetBy: 2)
            let end = editedMobileNumber.index(editedMobileNumber.endIndex, offsetBy: -3)
            editedMobileNumber.replaceSubrange(start..<end, with: "XX XXX")
            self.labelOtpMobileNUmber.text = "On \(editedMobileNumber)"
        }
    }
    
    func showOtpView(){
        //display the view
        UIView.animate(withDuration: 0.3, animations: {
            self.labelOtpMobileNUmber.alpha = 1.0
            self.viewOtp.alpha = 1.0
        }, completion: nil)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OtpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    @IBAction func sendotp(_ sender: Any) {
        if(delegate != nil){
            delegate.sendOtp()
        }
    }
    
    @IBAction func verifyOtp(_ sender: Any) {
        if(delegate != nil){
            delegate.verifyOtp()
        }
    }
}
