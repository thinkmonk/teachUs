//
//  SubmitAuthPasswordView.swift
//  TeachUs
//
//  Created by ios on 4/6/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol VerifyAuthPasswordProtocol {
    func dismissView()
    func verifypassword(numberOtp: String,  emailOTP:String)
}

class VerifyAuthPasswordView: UIView {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonDismissView: UIButton!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewEmailBg: UIView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var textfieldNumber: UITextField!
    @IBOutlet weak var viewNumberBg: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewTitleBackground: UIView!
    @IBOutlet weak var ViewFormBg: UIView!
    @IBOutlet weak var constraintEmailViewHeight: NSLayoutConstraint!
    
    var collegeClass:CollegeAttendanceList!
    var delegate : VerifyAuthPasswordProtocol!
    var numberPasswordText =  Variable<String>("")
    var emailPassWordText = Variable<String>("")
    let disposeBag = DisposeBag()
    var isValid:Observable<Bool>{
        return Observable.combineLatest(numberPasswordText.asObservable(), emailPassWordText.asObservable()){ number, email in
            return number.count == 4
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        if(delegate != nil){
            delegate.dismissView()
        }
    }
    
    @IBAction func verifyPasswords(_ sender: Any) {
        if(delegate != nil){
            delegate.verifypassword(numberOtp: self.textfieldNumber.text!, emailOTP: self.textFieldEmail.text!)
        }
    }
    
    //MARK:- Ciustom mthods
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame = inView.frame
        self.center.x = inView.centerX()
        inView.addSubview(self)
        self.setUpRX()
        //display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: { (result) in
            print("completion result is \(result)")
        })
    }
    
    func hideView(){
        self.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            self.removeFromSuperview()
        }, completion:nil)
    }
    
    func setUpUI(){
        self.constraintEmailViewHeight.constant = 0.0
        self.textFieldEmail.alpha = 0
        self.buttonSubmit.roundedRedButton()
        self.ViewFormBg.makeTableCellEdgesRounded()
        self.viewEmailBg.makeEdgesRoundedWith(radius: self.viewEmailBg.height()/2)
        self.viewNumberBg.makeEdgesRoundedWith(radius: self.viewNumberBg.height()/2)
        self.labelTitle.text = " \(self.collegeClass.courseName) Report"
    }
    
    func setUpRX(){
//        self.textFieldEmail.rx.text.map{ $0 ?? ""}.bind(to: self.emailPassWordText).disposed(by: disposeBag)
        self.textfieldNumber.rx.text.map{$0 ?? ""}.bind(to:self.numberPasswordText).disposed(by:disposeBag)
        self.isValid.subscribe(onNext: { (isValid) in
            self.buttonSubmit.alpha = isValid ? 1 : 0
        }).disposed(by: disposeBag)
    }
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "VerifyAuthPasswordView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
