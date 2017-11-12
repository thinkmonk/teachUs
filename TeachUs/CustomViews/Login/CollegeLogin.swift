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
    func sendCollegeOtp()
    func verifyCollegeOtp()
}

class CollegeLogin: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var viewCollege: UIView!
    @IBOutlet weak var buttonSelectCollege: UIButton!
    @IBOutlet weak var textfieldCollegeName: UITextField!
    
    
    @IBOutlet weak var viewsendOtp: UIView!
    
    @IBOutlet weak var viewMobileNumberTf: UIView!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var buttonSendOtp: UIButton!
    
    @IBOutlet weak var viewVerifyOtp: UIView!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var stackViewEnterOTp: UIStackView!
    @IBOutlet weak var textFieldOtp: UITextField!
    @IBOutlet weak var buttonVerifyOtp: UIButton!
    
    
    var disposeBag: DisposeBag! = DisposeBag()
    var delegate:CollegeLoginDelegate!
    var userType:LoginUserType!
    let picker = UIPickerView()
    var pickerDataSourceArray = ["Bangladesh","India","Pakistan","USA","Bangladesh","India","Pakistan","USA","Bangladesh","India","Pakistan","USA"]
    var mobileNumber = ""

    
    func setUpReactive()
    {
        let otpValid = textFieldOtp.rx.text.orEmpty
            .map { $0.characters.count > 0 }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        
        otpValid
            .bind(to: buttonVerifyOtp.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let mobileNumberValid = textFieldMobileNumber.rx.text.orEmpty
            .map { $0.characters.count == 10 }
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
        self.viewCollege.makeEdgesRoundedWith(radius: self.viewCollege.height()/2)
        self.viewMobileNumberTf.makeEdgesRoundedWith(radius: self.viewMobileNumberTf.height()/2)
        self.textFieldOtp.makeEdgesRoundedWith(radius: self.textFieldOtp.height()/2)
        
        self.buttonSendOtp.makeEdgesRoundedWith(radius: self.buttonSendOtp.height()/2)
        self.buttonSendOtp.roundedBlueButton()
        
        self.buttonVerifyOtp.makeEdgesRoundedWith(radius: self.buttonVerifyOtp.height()/2)
        self.buttonVerifyOtp.roundedRedButton()
    }
    
    @IBAction func showCollegeView(_ sender: Any) {
        self.textfieldCollegeName.becomeFirstResponder()
    }
    
    func setUpSelectCollegeView(){
        self.viewsendOtp.alpha = 0
        self.viewVerifyOtp.alpha = 0
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.setUpColleges(_:)))
        self.viewCollege.addGestureRecognizer(tap)
        self.viewCollege.isUserInteractionEnabled = true

        self.picker.showsSelectionIndicator = true
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.frame = CGRect(x: 0.0, y: 0, width: self.width(), height: 216)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.textfieldCollegeName.becomeFirstResponder()
        self.textfieldCollegeName.inputView = picker
        self.textfieldCollegeName.inputAccessoryView = toolBar

    }
    
    
    @objc func setUpColleges(_ sender: UITapGestureRecognizer) {
        self.viewsendOtp.alpha = 0
    }
    
    
    @IBAction func sendOtp(_ sender: UIButton) {
        self.mobileNumber = self.textFieldMobileNumber.text!
        if(delegate != nil){
            self.delegate.sendCollegeOtp()
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
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width()
        self.frame.size.height = inView.height()
        self.frame.origin.y = 0
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
    
    
    //MARK:- PICKER VIEW METHODS
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSourceArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSourceArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textfieldCollegeName.text = pickerDataSourceArray[row]
    }
    
    @objc func donePicker(){
        self.textfieldCollegeName.resignFirstResponder()
        self.viewsendOtp.alpha = 1
    }
}
