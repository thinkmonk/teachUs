//
//  AdmissionsViewController.swift
//  TeachUs
//
//  Created by iOS on 25/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionsViewController: BaseTableViewController    {

    var arrayDataSource = [AdmissionFormSectionDataSource]()
    var dataPicker = Picker(data: [[]])
    let toolBar = UIToolbar()
    let picker = UIDatePicker()
    var dobTextField:CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientNew()
        self.tableView.register(UINib(nibName: "AdmissionFormInputTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionCell)
        self.tableView.register(UINib(nibName: "AdmissionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionHeader)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.getyUserdetails()
        setupGeneriPicker()
        initDatePicker()
        addRightBarButton()
        addBackButton()
    }
    
    func getyUserdetails()
    {
        self.title = "Page 1/5"
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
    
    func initDatePicker(){
        picker.datePickerMode = .date
        picker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date())
        picker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)

    }
    
    @objc func updateDateField(sender: UIDatePicker) {
        dobTextField?.text = formatDateForDisplay(date: sender.date)
        if let textField = dobTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = arrayDataSource[indexPath.section].attachedObj[indexPath.row]
            let permanentAddressFlag = arrayDataSource[indexPath.section].sectionType == .PermanenttAddress
            cellDataSource.setValues(value: textField.text ?? "", otherObj: nil, ispermanenetAddress: permanentAddressFlag)
            arrayDataSource[indexPath.section].attachedObj[indexPath.row].attachedObject = textField.text
        }
    }

    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func addRightBarButton(){
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20 ))
        rightButton.setTitle("Proceed", for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rightButton.addTarget(self, action: #selector(proceedAction), for: .touchUpInside)
        rightButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // Bar button item
        let bellButtomItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItems  = [bellButtomItem]

    }
    
    func addBackButton(){
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.showAlertWithTitleAndCompletionHandlers(nil, alertMessage: "Do you want to save before exit", okButtonString: "Yes", canelString: "No", okAction: {//ok flow
            AdmissionFormManager.shared.sendFormOneData({ (dict) in
                if let id = dict?["admission_form_id"] as? String, let _id = Int(id){
                    AdmissionBaseManager.shared.formID = _id
                }
                self.navigationController?.popViewController(animated: true)
            }) {
                self.showAlertWithTitle("Failed", alertMessage: "Please Retry")
            }
            
        }) { //cancel flow
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc func proceedAction(){
        self.view.endEditing(true)
        if (AdmissionFormManager.shared.validateData()){
            AdmissionFormManager.shared.sendFormOneData({ (dict) in
//                if let message  = dict?["message"] as? String{
//                    self.showAlertWithTitle("Success", alertMessage: message)
//                }
                if let id = dict?["admission_form_id"] as? String, let _id = Int(id){
                    AdmissionBaseManager.shared.formID = _id
                }
                self.performSegue(withIdentifier: Constants.segues.toSubjectForm, sender: self)

            }) {
                self.showAlertWithTitle("Failed", alertMessage: "Please Retry")
            }
        }else{
            self.showAlertWithTitle("Failed", alertMessage: "Please fill up all the required text fields")
        }
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
    
    @objc func donePicker(){
        self.dataPicker.isHidden = true
        self.view.endEditing(true)
        
        //refresh table view cell if the dob text field is selected
        if let textField = dobTextField,
            let indexPath = textField.indexpath,
        arrayDataSource[indexPath.section].attachedObj[indexPath.row].cellType == .DOB
        {
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }

    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let infodsObj = AdmissionFormManager.shared.makePersonalInfoDataSource()
        let infozsection = AdmissionFormSectionDataSource(sectionType: .Profile, obj: infodsObj)
        
        self.arrayDataSource.append(infozsection)
        
        
        let correspondingAddress = AdmissionFormManager.shared.getAddressDataSource(false, isCopy: false)
        let correspondingAddressSection = AdmissionFormSectionDataSource(sectionType: .CorrespondingAddress, obj: correspondingAddress)
        self.arrayDataSource.append(correspondingAddressSection)
        
        let permanantAddress = AdmissionFormManager.shared.getAddressDataSource(true, isCopy: false)
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
            cell.delegate = self
            cell.setUPcell(dsObject: cellDataSource)
            
            return cell
            
        case .SureName,
             .FirstName,
             .FathersName,
             .MothersName,
             .NameOnMarkSheet,
             .DevnagriName,
             .Caste,
             .Nationality,
             .RoomFloorBldg,
             .AreaLandamrk,
             .City,
             .Country:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = true
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.keyboardType = .default
            cell.textFieldAnswer.delegate = self
            
            return cell

        case .PinCode:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = true
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.keyboardType = .default
            cell.textFieldAnswer.delegate = self
            cell.textFieldAnswer.keyboardType = .numberPad
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
            cell.textFieldAnswer.delegate = self
            cell.textFieldAnswer.indexpath = indexPath
            
            return cell
            
        case .Aadhar:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.textFieldAnswer.keyboardType = .numberPad
            cell.buttonDropdown.isHidden = true
            cell.textFieldAnswer.delegate = self
            cell.textFieldAnswer.indexpath = indexPath
            
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
            cell.buttonDropdown.isHidden = false
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.delegate = self
            
            
            return cell
            
        case .DOB:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.delegate = self
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.inputView = picker
            cell.textFieldAnswer.text = formatDateForDisplay(date: picker.date)
            cell.textFieldAnswer.indexpath = indexPath
            cell.labelFormHeader.text = cellDataSource.cellType.rawValue
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
                    if let _stringObj = stringObj.first as? String{
                        textField.text = _stringObj
                    }
                }
                dataPicker.manuallySelectRow(row: 0, componnent: 0)
            }else if cellDataSource.cellType == .DOB{
                dobTextField = textField
                textField.inputAccessoryView = toolBar
                textField.inputView = picker

            }else{
                textField.inputView = nil
                textField.inputAccessoryView = nil
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = arrayDataSource[indexPath.section].attachedObj[indexPath.row]
            let permanentAddressFlag = arrayDataSource[indexPath.section].sectionType == .PermanenttAddress
            cellDataSource.setValues(value: textField.text ?? "", otherObj: nil, ispermanenetAddress: permanentAddressFlag)
            arrayDataSource[indexPath.section].attachedObj[indexPath.row].attachedObject = textField.text
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    
}

extension AdmissionsViewController:AdmissionHeaderTableViewCellDelegate{
    func copyCorrespondenceAddress() {
        for (index,value) in self.arrayDataSource.enumerated(){
            if value.sectionType == .PermanenttAddress{
                arrayDataSource.remove(at: index)
                let coresspondingAddress = AdmissionFormManager.shared.getAddressDataSource(false, isCopy: true)
                let permanentAddressSection = AdmissionFormSectionDataSource(sectionType: .PermanenttAddress, obj: coresspondingAddress)
                arrayDataSource.insert(permanentAddressSection, at: index)
                DispatchQueue.main.async {
                    self.tableView.reloadSections([index], with: .fade)
                }
            }
            
        }
    }
    
    
}
