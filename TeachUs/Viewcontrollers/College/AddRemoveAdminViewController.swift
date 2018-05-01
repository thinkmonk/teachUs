//
//  AddRemoveAdminViewController.swift
//  TeachUs
//
//  Created by ios on 4/16/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import  ObjectMapper
import RxCocoa
import RxSwift


class AddRemoveAdminViewController: BaseViewController {

    @IBOutlet var isSuperAdmin:UISwitch!
    
    @IBOutlet weak var viewRemoveAdminPhoneNumber: UIView!
    @IBOutlet weak var textfieldRemoveAdminPhoneNumber: UITextField!
    @IBOutlet weak var buttonRemoveAdmin: UIButton!
    @IBOutlet weak var viewAddAdminPhoneNumber: UIView!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var buttonAdd: UIButton!
    
    let adminDropdown = DropDown()
    var parentNavigationController : UINavigationController?
    var arrayAdminList:[Admin] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAdminList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAddAdminPhoneNumber.makeViewCircular()
        self.viewRemoveAdminPhoneNumber.makeViewCircular()
        self.buttonRemoveAdmin.roundedgreyButton()
        self.buttonAdd.roundedRedButton()
        self.setUpRx()

    }
    
    //MARK:- Outlet methods
    @IBAction func adminTypeChanged(_ sender: Any) {
        self.getAdminList()
    }
    
    @IBAction func addNewAdmin(_ sender: Any) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.addAmin
        let adminType  = isSuperAdmin.isOn ? "1" : "2"
        let parameters = [
            "college_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_id!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "contact":"\(self.textFieldPhoneNumber.text!)",
            "admin_type":"\(adminType)"
        ]
        manager.apiPost(apiName: " Add new admin", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    @IBAction func removeAdmin(_ sender: Any) {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.removeAdmin
        let parameters = [
            "college_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_id!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "contact":"\(self.textFieldPhoneNumber.text!)"
        ]
        manager.apiPost(apiName: " Remove admin", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            let status = response["status"] as! Int
            if (status == 200){
                let message:String = response["message"] as! String
                self.showAlterWithTitle(nil, alertMessage: message)
            }
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func getAdminList(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.getAdminList
        let adminType  = isSuperAdmin.isOn ? "1" : "2"
        let parameters = [
            "college_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_id!)",
            "role_id":"\(UserManager.sharedUserManager.appUserCollegeDetails.role_id!)",
            "admin_type":"\(adminType)"
        ]
        
        manager.apiPost(apiName: " Get all admin list", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            guard let adminListArray = response["admin_list"] as? [[String:Any]] else{
                return
            }
            self.arrayAdminList.removeAll()
            for admin in adminListArray{
                let tempList = Mapper<Admin>().map(JSONObject: admin)
                self.arrayAdminList.append(tempList!)
            }
            self.setupDropdown()
        }) { (error, code, message) in
            self.showAlterWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func setUpRx(){
        /*
        self.textfieldRemoveAdminPhoneNumber.rx.text.asObservable()
            .subscribe({ (text) in
                print("editing state changed")
                self.adminDropdown.show()
            }).disposed(by: disposeBag)
        
        self.textFieldPhoneNumber.rx.text.asObservable()
            .subscribe(onNext: { (text) in
                self.adminDropdown.hide()
            }).disposed(by: disposeBag)
 
        self.textfieldRemoveAdminPhoneNumber.rx.text
        .asObservable()
            .subscribe({ (text) in
                _ = text.map({ (textString)  in
                    self.buttonRemoveAdmin.alpha = textString?.count == 10 ? 1 : 0
                })
            }).disposed(by: disposeBag)
         */

        self.textfieldRemoveAdminPhoneNumber.rx.controlEvent([UIControlEvents.editingDidBegin, UIControlEvents.editingChanged])
        .asObservable()
            .subscribe(onNext: { () in
                self.adminDropdown.show()
            }).disposed(by: disposeBag)
        
        self.textfieldRemoveAdminPhoneNumber.rx.controlEvent([UIControlEvents.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { () in
                self.adminDropdown.hide()
            }).disposed(by: disposeBag)
    }
    
    func setupDropdown(){
        self.adminDropdown.anchorView = self.viewRemoveAdminPhoneNumber
        self.adminDropdown.bottomOffset = CGPoint(x: 0, y: viewRemoveAdminPhoneNumber.height())
        self.adminDropdown.width = self.viewRemoveAdminPhoneNumber.width()
        self.adminDropdown.dataSource.removeAll()
        for admin in self.arrayAdminList{
            self.adminDropdown.dataSource.append(admin.contact)
        }
        self.adminDropdown.selectionAction = { [unowned self] (index, item) in
                self.textfieldRemoveAdminPhoneNumber.text = "\(self.arrayAdminList[index].contact)"
        }
        DropDown.appearance().backgroundColor = UIColor.white
    }
}

extension AddRemoveAdminViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Add/Remove Admin")
    }
}
