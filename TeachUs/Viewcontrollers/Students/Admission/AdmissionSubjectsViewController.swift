//
//  AdmissionSubjectsViewController.swift
//  TeachUs
//
//  Created by iOS on 31/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionSubjectsViewController: BaseTableViewController {

    
    var dataPicker = Picker(data: [[]])
    let toolBar = UIToolbar()
    var formId:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGeneriPicker()
        addRightBarButton()
        self.getyUserdetails()


    }


    func getyUserdetails()
       {
           self.title = "Page 2/4"
           LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
           let manager = NetworkHandler()
           manager.url = URLConstants.Admission.getCampusClass
           let parameters = [
               "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
               "role_id": "\(1)",
            "admission_form_id":"\(formId)"
           ]
        
           manager.apiPostWithDataResponse(apiName: "Get class subject data for admission", parameters:parameters, completionHandler: { (result, code, response) in
               LoadingActivityHUD.hideProgressHUD()
               do{
                   let decoder = JSONDecoder()
                AdmissioSubjectManager.shared.subjectData = try decoder.decode(AdmissioSubjectnData.self, from: response)
               } catch let error{
                   print("err", error)
               }
           }) { (error, code, message) in
               print(message)
               LoadingActivityHUD.hideProgressHUD()
           }
       }
       
       func addRightBarButton(){
           let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20 ))
           rightButton.setTitle("Proceed", for: .normal)
           rightButton.setTitleColor(.white, for: .normal)
           rightButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
           rightButton.addTarget(self, action: #selector(proceedAction), for: .touchUpInside)
           
           // Bar button item
           let bellButtomItem = UIBarButtonItem(customView: rightButton)
           navigationItem.rightBarButtonItems  = [bellButtomItem]

       }
    
    
    func setupGeneriPicker(){
        let height = UIScreen.main.bounds.height * 0.35
        let width  = UIScreen.main.bounds.width
        let yPosi  = UIScreen.main.bounds.height - height
        let frame = CGRect(x: 0, y: yPosi, width: width, height: height)
        dataPicker.frame = frame
        dataPicker.backgroundColor = .lightGray
        dataPicker.isHidden = true
    
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func proceedAction(){
        self.view.endEditing(true)
        if (AdmissionFormManager.shared.validateData()){
            AdmissionFormManager.shared.sendFormOneData({ (dict) in
                if let message  = dict?["message"] as? String{
                    self.showAlertWithTitle("Success", alertMessage: message)
                }
                if let id = dict?["admission_form_id"] as? Int{
                    self.formId = id
                }
            }) {
                self.showAlertWithTitle("Failed", alertMessage: "Please Retry")
            }
        }else{
            self.showAlertWithTitle("Failed", alertMessage: "Please fill up all the required text fields")
        }
    }
    
    @objc func donePicker(){
        self.dataPicker.isHidden = true
        self.view.endEditing(true)
    }


}
