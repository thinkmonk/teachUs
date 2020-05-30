//
//  AdmissionsViewController.swift
//  TeachUs
//
//  Created by iOS on 25/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionsViewController: BaseTableViewController {

    var arrayDataSource = [AdmissionFormSectionDataSource]()
    
    override func viewDidLoad() {
        self.addGrdientToNavBar()
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AdmissionFormInputTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionCell)
        self.tableView.register(UINib(nibName: "AdmissionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionHeader)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.getyUserdetails()
        setupGeneriPicker()
    }
    
    func getyUserdetails()
    {
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.getAdmssionStudentInfo
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id": "\(1)"
        ]
        manager.apiPostWithDataResponse(apiName: "Get Studetn data for admission", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                AdmissionFormManager.shared.admissionData = try decoder.decode(AdmissionData.self, from: response)
                self.makeDataSource()
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    var dataPicker = Picker(data: [[]])
    let toolBar = UIToolbar()

    
    func setupGeneriPicker(){
//        let stringArray = [["A","B","C"]]
        let height = UIScreen.main.bounds.height * 0.35
        let width  = UIScreen.main.bounds.width
        let yPosi  = UIScreen.main.bounds.height - height
        let frame = CGRect(x: 0, y: yPosi, width: width, height: height)
//        let pickerObj = Picker(data: stringArray)
//        pickerObj.data = stringArray
//
//        pickerObj.selectionUpdated = { stringArray in
//            print(stringArray)
//        }
        
        dataPicker.frame = frame
//        self.view.addSubview(dataPicker)
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
    
    @objc func donePicker(){
        self.dataPicker.isHidden = true
        self.view.endEditing(true)
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let infodsObj = AdmissionFormManager.shared.makePersonalInfoDataSource()
        let infozsection = AdmissionFormSectionDataSource(sectionType: .Profile, obj: infodsObj)
        
        self.arrayDataSource.append(infozsection)
        
        
        let correspondingAddress = AdmissionFormManager.shared.getAddressDataSource(false)
        let correspondingAddressSection = AdmissionFormSectionDataSource(sectionType: .CorrespondingAddress, obj: correspondingAddress)
        self.arrayDataSource.append(correspondingAddressSection)
        
        let permanantAddress = AdmissionFormManager.shared.getAddressDataSource(true)
        let permanentAddressSection = AdmissionFormSectionDataSource(sectionType: .PermanenttAddress, obj: permanantAddress)
        self.arrayDataSource.append(permanentAddressSection)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension AdmissionsViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataSource[section].rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayDataSource[indexPath.section].attachedObj[indexPath.row]
        switch cellDataSource.cellType {
        case .PersonalInfo,
             .CorrespondanceAddress,
             .PermannentAddress:
            let cell:AdmissionHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionHeader, for: indexPath) as! AdmissionHeaderTableViewCell
            cell.setUPcell(dsObject: cellDataSource)
            
            return cell
            
        case .SureName,
             .FirstName,
             .FathersName,
             .MothersName,
             .NameOnMarkSheet,
             .DevnagriName,
             .DOB,
             .Caste,
             .Nationality,
             .RoomFloorBldg,
             .AreaLandamrk,
             .City,
             .PinCode,
             .Country:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = true
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.keyboardType = .default
            return cell
            
        case .MobileNumber:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = true
            cell.textFieldAnswer.text = AdmissionFormManager.shared.admissionData.personalInformation?.contact ?? UserManager.sharedUserManager.getUserMobileNumber()
            return cell
            
        case .EmailAddress:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.textFieldAnswer.keyboardType = .emailAddress
            cell.buttonDropdown.isHidden = true
            
            return cell
            
        case .Aadhar:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.textFieldAnswer.keyboardType = .numberPad
            cell.buttonDropdown.isHidden = true

            return cell
            
        case .Category,
             .Religiion,
             .Gender,
             .Domicile,
             .MotherTongue,
             .MaritialStatus,
             .BloodGroup:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = false
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.delegate = self
            
            return cell
            
        case .State:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = true
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.delegate = self


            return cell
            
        case .none:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell

            return cell
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}


extension AdmissionsViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = arrayDataSource[indexPath.section].attachedObj[indexPath.row]
            if let attachedOBj = cellDataSource.dataSourceObject as? [String]{
                dataPicker.data = [attachedOBj]
                dataPicker.isHidden = false
                dataPicker.selectionUpdated = { stringObj in
                    if let `stringObj` = stringObj.first as? String{
                        textField.text = `stringObj`
                    }
                }
            }else{
                textField.inputView = nil
                textField.inputAccessoryView = nil
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
                if let `textField` = textField as? CustomTextField{
            
        }

    }
}
