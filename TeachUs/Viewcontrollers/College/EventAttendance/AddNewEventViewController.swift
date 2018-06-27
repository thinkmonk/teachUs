//
//  AddNewEventViewController.swift
//  TeachUs
//
//  Created by ios on 4/7/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNewEventViewController: BaseViewController {

    @IBOutlet weak var viewtextFieldNameBg: UIView!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewAddEventBg: UIView!
    @IBOutlet weak var viewtitleBg: UIView!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewEventViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewEventViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.buttonSubmit.themeRedButton()
        self.buttonSubmit.makeViewCircular()
        self.viewAddEventBg.makeEdgesRounded()
        viewtextFieldNameBg.makeEdgesRoundedWith(radius: viewtextFieldNameBg.height()/2)
    }
    
    //MARK:- Outlet Methods
    
    @IBAction func addNewEvent(_ sender: Any) {
        let date = Date()
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultDateString = inputFormatter.string(from: date)

        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.addNewEvent
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "event_name":"\(self.textfieldName.text!)",
            "event_code":"\(self.textfieldName.text!)",
            "event_description":"lorem ipsum",
            "event_date":"\(resultDateString)"
        ]
        
        manager.apiPost(apiName: " Add new Event", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
                self.closeView(self)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Custom methods
    
    func setUpRx(){
        let isEventNameValid: Observable<Bool> = self.textfieldName.rx.text
            .map{ text -> Bool in
                return text!.count >= 2
            }
            .share(replay: 1)
        
        isEventNameValid.subscribe( onNext:{ isValid in
            self.buttonSubmit.alpha = isValid ? 1 : 0
        }).disposed(by: disposeBag)
    }
    
    //MARK:- Keyboard show/hide notification.
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
                if((self.buttonSubmit.origin().y+self.viewAddEventBg.origin().y) >= (self.view.height()-keyboardSize.height) && self.view.frame.origin.y == 0)
                {
                    self.view.frame.origin.y -= keyboardSize.height/2
                }
            }
        }
    
@objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

//MARK:- text view delegate
extension AddNewEventViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
