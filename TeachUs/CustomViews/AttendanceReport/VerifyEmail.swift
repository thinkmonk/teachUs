//
//  VerifyEmail.swift
//  TeachUs
//
//  Created by ios on 3/9/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol verifyEmailDelegae {
    func emailSubmitted()
    func otpSubmitted()
}

class VerifyEmail: UIView {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var labelClassNameText: UILabel!
    @IBOutlet weak var labelEmailId: UILabel!
    @IBOutlet weak var viewEmailtextFieldBg: UIView!
    @IBOutlet weak var textfieldEmail: UITextField!
    
    @IBOutlet weak var viewVerifyOtpbg: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var layoutVerifyOtpHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldOtp: UITextField!
    @IBOutlet weak var buttonOtp: UIButton!
    let myDisposeBag = DisposeBag()
    var delegate:verifyEmailDelegae!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewBg.makeEdgesRounded()
        self.buttonSubmit.themeRedButton()
        self.buttonOtp.themeRedButton()
        self.viewVerifyOtpbg.alpha = 0
        self.layoutVerifyOtpHeight.constant = 0
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        self.textfieldEmail.rx.text.orEmpty
            .bind(to: CollegeClassManager.sharedManager.email).disposed(by: myDisposeBag)
        CollegeClassManager.sharedManager.email.asObservable().subscribe(onNext: { (newEmail) in
            self.buttonSubmit.alpha =  newEmail.isValidEmailAddress() ? 1 : 0
        }).disposed(by: myDisposeBag)
    }
    
    @IBAction func actionSubmitEMail(_ sender: Any) {
        self.delegate.emailSubmitted()
    }
    
    @IBAction func actionSubmitOtp(_ sender: Any) {
        self.delegate.otpSubmitted()
    }
    
    @IBAction func closeEmailVIew(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "VerifyEmail", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
