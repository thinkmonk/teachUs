//
//  Login.swift
//  TeachUs
//
//  Created by ios on 10/26/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


protocol LoginDelegate {
    func submitDetails()
}

class LoginView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textfieldFirstName: UITextField!
    @IBOutlet weak var textfieldSurname: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewFirstNameBg: UIView!
    @IBOutlet weak var viewSurnameBg: UIView!
    
    @IBOutlet weak var textFieldEmailId: UITextField!
    @IBOutlet weak var viewemailIdBg: UIView!

    var disposeBag: DisposeBag! = DisposeBag()
    var delegate:LoginDelegate!
    var userType:LoginUserType!
    var firstNameText = Variable<String>("")
    var middleNameText = Variable<String>("")
    var surnameText = Variable<String>("")
    var activeTextFIeld:UITextField!

    var isvalid:Observable<Bool>{
        return Observable.combineLatest(firstNameText.asObservable(), middleNameText.asObservable(), surnameText.asObservable()){ name, middleName, surname in
            name.count > 0 && middleName.count > 0 && surname.count > 0
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpReactive()
    {
        /*
        self.textfieldFirstName.rx.text.map{ $0 ?? ""}.bind(to: self.firstNameText).disposed(by: disposeBag)
        self.textfieldMiddleName.rx.text.map { $0 ?? "" }.bind(to: self.middleNameText).disposed(by: disposeBag)
        self.textfieldSurname.rx.text.map{ $0 ?? ""}.bind(to: self.surnameText).disposed(by: disposeBag)
        self.isvalid.subscribe( onNext:{ isValid in
            if(isValid){
                self.buttonSubmit.alpha = 1;
            }
            else{
                self.buttonSubmit.alpha = 0;
            }
        }).disposed(by: disposeBag)
        */
        
        let isEmailValid: Observable<Bool> = textFieldEmailId.rx.text
            .map{ text -> Bool in
                return text!.isValidEmailAddress()
            }
            .share(replay: 1)
        
        isEmailValid.subscribe( onNext:{ isValid in
            self.buttonSubmit.alpha = isValid ? 1 : 0
        }).disposed(by: disposeBag)
    }
    
    func setUpView(){
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
        self.textfieldFirstName.delegate = self
        self.textFieldEmailId.delegate = self
        self.textfieldSurname.delegate = self

        self.viewFirstNameBg.makeEdgesRoundedWith(radius: self.viewFirstNameBg.height()/2)
        self.viewemailIdBg.makeEdgesRoundedWith(radius: self.viewemailIdBg.height()/2)
        self.viewSurnameBg.makeEdgesRoundedWith(radius: self.viewSurnameBg.height()/2)
        self.buttonSubmit.roundedRedButton()
    }
    
    func showView(inView:UIView){
        self.alpha = 0.0
        self.frame.size.width = inView.width() * 0.9
        self.frame.origin.y = inView.height()*0.30
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
    
    func hideView(){
        self.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            self.removeFromSuperview()
        }, completion:nil)
    }
    
    @IBAction func submitUserDetails(_ sender: Any) {
        if(self.delegate != nil){
            UserManager.sharedUserManager.userName = self.textfieldFirstName.text!
            UserManager.sharedUserManager.userEmail = self.textFieldEmailId.text!
            UserManager.sharedUserManager.userLastName = self.textfieldSurname.text!
            delegate.submitDetails()
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LoginView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    //MARK: - TextField delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextFIeld = textField
    }
}
