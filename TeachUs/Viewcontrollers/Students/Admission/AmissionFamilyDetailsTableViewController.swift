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
    var arrayDataSource = [FamilySectionCellData]()
    var dobTextField:CustomTextField!
    let picker = UIDatePicker()
    var ageMotherIndexpath:IndexPath?
    var ageFatherIndexpath:IndexPath?

    
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
        picker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date())
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
            "admission_form_id":"\(AdmissionBaseManager.shared.formID ?? 0)",
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
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 25  ))
        rightButton.setTitle("Proceed", for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rightButton.addTarget(self, action: #selector(proceedAction), for: .touchUpInside)
        rightButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
            
            AdmissionFamilyManager.shared.sendformFourData(formId: AdmissionBaseManager.shared.formID, { (dict) in
                if let message  = dict?["message"] as? String{
                    self.showAlertWithTitle("Success", alertMessage: message)
                }
            }) {
                self.showAlertWithTitle("Failed", alertMessage: "Please Retry")
            }
        }else{
            self.showAlertWithTitle("Failed", alertMessage: "Please fill up all the required text fields")
        }
        self.performSegue(withIdentifier: Constants.segues.toDocumentsView, sender: self)
    }
    
    @objc func donePicker(){
        self.dataPicker.isHidden = true
        self.view.endEditing(true)
        self.tableView.reloadData()
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
            cell.textFieldAnswer.isUserInteractionEnabled = true
            return cell

        case .fullName,
             .age,
             .contactNumber,
             .emailAddress,
             .countryOfWork:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.delegate = self
            cell.setUpCell(cellDataSource)
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.isUserInteractionEnabled = (cellDataSource.cellType != .age)
            
            let datadourceObj = AdmissionFamilyManager.shared.dataSource[indexPath.section]
            if datadourceObj.headerType == .father, datadourceObj.attachedObj[indexPath.row].cellType == .age{
                self.ageFatherIndexpath = indexPath
            }
            if datadourceObj.headerType == .father, datadourceObj.attachedObj[indexPath.row].cellType == .age{
                self.ageMotherIndexpath = indexPath
            }
            
            return cell

        case .DOB:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.delegate = self
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.inputView = picker
            cell.textFieldAnswer.text = cellDataSource.attachedObj as? String
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.isUserInteractionEnabled = true
            cell.labelFormHeader.text = cellDataSource.cellType.rawValue
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
                dataPicker.manuallySelectRow(row: 0, componnent: 0)
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
            AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row].attachedObj = dobTextField?.text
            let age =  getAge()
            var indexSection:Int?
            for (index,obj) in AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj.enumerated(){
                if (obj.cellType == .age)
                {
                    indexSection = index
                }
            }
            if let `indexSection` = indexSection{
                
                let cellDataSource = AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexSection]
                cellDataSource.setValues(value: textField.text ?? "", otherObj: age, indexPath: indexPath)
                cellDataSource.attachedObj = age
                AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexSection].attachedObj = age
                if let motherIp = ageFatherIndexpath, let fatherIp = ageFatherIndexpath{
                    self.tableView.reloadRows(at: [motherIp,fatherIp], with: .none)
                }
            }
        }
    }
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func getAge() -> Int{
        let now = Date()
        let birthday: Date = picker.date
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year ?? 0

    }


    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = AdmissionFamilyManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
            if cellDataSource.cellType == .DOB{
                cellDataSource.setValues(value: textField.text ?? "", otherObj: textField.text, indexPath: indexPath)
//                if let motherIp = ageFatherIndexpath, let fatherIp = ageFatherIndexpath{
//                    self.tableView.reloadRows(at: [motherIp,fatherIp], with: .none)
//                }
            }else{
                cellDataSource.setValues(value: textField.text ?? "", otherObj: nil, indexPath: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        }
        
    }
    
    
}
