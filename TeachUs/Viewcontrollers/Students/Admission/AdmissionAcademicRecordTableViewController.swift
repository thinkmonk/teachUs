//
//  AdmissionAcademicRecordTableViewController.swift
//  TeachUs
//
//  Created by iOS on 01/06/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionAcademicRecordTableViewController: BaseTableViewController {
    
    var dataPicker = Picker(data: [[]])
    let toolBar = UIToolbar()

    var arrayDataSource = [AcademicSectionDataSource]()
    var activetextField:CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "RecordHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.recordTitleHeaderCell)
        self.tableView.register(UINib(nibName: "AddRecordTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.addRecordCell)
        self.tableView.register(UINib(nibName: "AdmissionFormInputTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionCell)
        self.tableView.register(UINib(nibName: "AdmissionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionHeader)
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        setupGeneriPicker()
        addRightBarButton()
        self.getRecordData()
        
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
        if (AdmissionResultManager.shared.validateaAllInputData()){
            
            AdmissionResultManager.shared.sendFormThreeData(formId: AdmissionBaseManager.shared.formID ?? 0, { (dict) in
                if let message  = dict?["message"] as? String{
                    self.performSegue(withIdentifier: Constants.segues.toFamilyInfo, sender: self)
                    self.showAlertWithTitle("Success", alertMessage: message)
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
    
    
    func getRecordData(){
        self.title = "Page 3/5"
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.getrecordData
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id": "\(1)",
            "admission_form_id":"\(AdmissionBaseManager.shared.formID ?? 0)",
        ]
        
        manager.apiPostWithDataResponse(apiName: "get admission record data", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                var data = try decoder.decode(AdmissionAcademicRecord.self, from: response)
                AdmissionResultManager.shared.recordData = data
                AdmissionResultManager.shared.makeDataSource()
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
    
    @objc func deleteRecord(_ sender:ButtonWithIndexPath){
        if let indexPath = sender.indexPath{
            AdmissionResultManager.shared.removeRecordAtIndexPath(at: indexPath, completetion: {
                self.tableView.reloadData()
                self.showAlertWithTitle("Success", alertMessage: "Record deleted succesfully")
            })
        }
    }
    
    @objc func addnewRecord(){
        AdmissionResultManager.shared.addNewAcademicRecord(completetion: {
            self.tableView.reloadData()
            self.showAlertWithTitle("Success", alertMessage: "Record added succesfully")

        })
        
    }

}



// MARK: - Table view data source
extension AdmissionAcademicRecordTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return AdmissionResultManager.shared.dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdmissionResultManager.shared.dataSource[section].rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = AdmissionResultManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
        switch cellDataSource.cellType{
        case .academincRecordHeader,
             .recordHeader:
            let cell:AdmissionHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionHeader, for: indexPath) as! AdmissionHeaderTableViewCell
            cell.setUpCell(dsObject: cellDataSource)
            return cell
            
        case .inHouse,
             .academicYear,
             .semester,
             .resultDeclared,
             .grade,
             .passingMonth,
             .passingYear,
             .atkt:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpCell(cellDataSource)
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.delegate = self
            return cell
            
            
        case .degreeName,
             .mediumOfInstruction,
             .degreeDuration,
             .SchemeOfExamination,
             .discipline,
             .prnNuber,
             .unversityName,
             .InstituteName,
             .markingSystem,
             .cgpa,
             .creditEarned:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.delegate = self
            cell.setUpCell(cellDataSource)
            cell.textFieldAnswer.indexpath = indexPath
            return cell
            
        case .recordNumberHeader:
            let cell:RecordHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.recordTitleHeaderCell, for: indexPath) as! RecordHeaderTableViewCell
            if let title = cellDataSource.attachedObj as? String{
                cell.labelrecordNumber.text = title
            }
            cell.buttonDeleteRecord.indexPath = indexPath
            cell.buttonDeleteRecord.addTarget(self, action: #selector(AdmissionAcademicRecordTableViewController.deleteRecord(_:)), for: .touchUpInside)
            return cell
            
        case .addNewRecord:
            let cell:AddRecordTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.addRecordCell, for: indexPath) as! AddRecordTableViewCell
            cell.buttonaddResult.addTarget(self, action: #selector(AdmissionAcademicRecordTableViewController.addnewRecord), for: .touchUpInside)
            return cell
            
        case  .none:
            let cell:RecordHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! RecordHeaderTableViewCell
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


}


extension AdmissionAcademicRecordTableViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = AdmissionResultManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
            if let attachedOBj = cellDataSource.attachedDs as? [String]{
                dataPicker.data = [attachedOBj]
                dataPicker.isHidden = false
                dataPicker.selectionUpdated = { stringObj in
                    if let `stringObj` = stringObj.first as? String{
                        textField.text = `stringObj`
                    }
                }
                dataPicker.manuallySelectRow(row: 0, componnent: 0)
            }else{
                textField.inputView = nil
                textField.inputAccessoryView = nil
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let `textField` = textField as? CustomTextField,
            let indexPath = textField.indexpath
        {
            let cellDataSource = AdmissionResultManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row]
            cellDataSource.setValues(value: textField.text ?? "", otherObj: nil, indexPath: indexPath)
            AdmissionResultManager.shared.dataSource[indexPath.section].attachedObj[indexPath.row].attachedObj = textField.text ?? ""
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            if cellDataSource.cellType == .resultDeclared{
                AdmissionResultManager.shared.makeDataSource()
                self.tableView.reloadSections([indexPath.section], with: .fade)
            }
        }
        
    }
    
    
}
