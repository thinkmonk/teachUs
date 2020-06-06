//
//  AmissionFamilyDetailsTableViewController.swift
//  TeachUs
//
//  Created by iOS on 05/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionFamilyDetailsTableViewController: BaseTableViewController {
    
    var dataPicker = Picker(data: [[]])
    let toolBar = UIToolbar()
    var formId:Int!
    var arrayDataSource = [FamilySectionCellData]()
    var dobTextField:CustomTextField!
    let picker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AdmissionFormInputTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionCell)
        self.tableView.register(UINib(nibName: "AdmissionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionHeader)
        self.tableView.register(UINib(nibName: "RecordHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.recordTitleHeaderCell)

        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        setupGeneriPicker()
        addRightBarButton()
        initDatePicker()
        self.getRecordData()
    }
    
    func initDatePicker(){
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)

    }
    
    func getRecordData(){
        self.title = "Page 4/5"
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.familyData
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id": "\(1)",
            "admission_form_id":"\(formId ?? 0)",
        ]
        
        manager.apiPostWithDataResponse(apiName: "get family data record data", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(AdmissionFamilyDetails.self, from: response)
                AdmissionFamilyManager.shared.familyData = data
                AdmissionFamilyManager.shared.makeSectionDataSurce()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        if (AdmissionFamilyManager.shared.validateaAllInputData()){
            
            AdmissionFamilyManager.shared.sendformFourData(formId: self.formId, { (dict) in
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
        self.performSegue(withIdentifier: Constants.segues.toDocumentsView, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toDocumentsView, let destinationVC:AdmissionDocumentPicketTableViewCell = segue.destination as? AdmissionDocumentPicketTableViewCell{
            destinationVC.formId = self.formId
        }
    }
    
    @objc func donePicker(){
        self.dataPicker.isHidden = true
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return AdmissionFamilyManager.shared.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AdmissionFamilyManager.shared.dataSource[section].rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
        switch cellDataSource.cellType{
        case .FamilyDetailsSection:
            let cell:AdmissionHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionHeader, for: indexPath) as! AdmissionHeaderTableViewCell
            cell.setUpCell(dsObject: cellDataSource)
            return cell
            
        case .fathersDetails,.mothersDetails:
            let cell:RecordHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.recordTitleHeaderCell, for: indexPath) as! RecordHeaderTableViewCell
            cell.labelrecordNumber.text = "\(cellDataSource.cellType.rawValue)"
            cell.buttonDeleteRecord.isHidden = true
            return cell

            
        case .profession,
             .totalIncome:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpCell(cellDataSource)
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.delegate = self
            return cell

        case .fullName,
             .age,
             .contactNumber,
             .emailAddress,
             .industry,
             .countryOfWork:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.delegate = self
            cell.setUpCell(cellDataSource)
            cell.textFieldAnswer.indexpath = indexPath
            return cell

        case .DOB:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.delegate = self
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.inputView = picker
            cell.textFieldAnswer.text = formatDateForDisplay(date: picker.date)
            cell.textFieldAnswer.indexpath = indexPath
            return cell
            
        default:
            return UITableViewCell()

        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
}
extension AdmissionFamilyDetailsTableViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
            if let attachedOBj = cellDataSource.attachedDs as? [String]{
                dataPicker.data = [attachedOBj]
                dataPicker.isHidden = false
                dataPicker.selectionUpdated = { stringObj in
                    if let `stringObj` = stringObj.first as? String{
                        textField.text = `stringObj`
                    }
                }
            }else if cellDataSource.cellType == .DOB{
                dobTextField = textField
                textField.inputAccessoryView = toolBar
                textField.inputView = picker

            }
            else{
                textField.inputView = nil
                textField.inputAccessoryView = nil
            }
        }
    }
    
    @objc func updateDateField(sender: UIDatePicker) {
        dobTextField?.text = formatDateForDisplay(date: sender.date)
        if let textField = dobTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
            cellDataSource.setValues(value: textField.text ?? "", otherObj: nil, indexPath: indexPath)
        }
    }
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }


    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
            cellDataSource.setValues(value: textField.text ?? "", otherObj: nil, indexPath: indexPath)
        }
        
    }
    
    
}
