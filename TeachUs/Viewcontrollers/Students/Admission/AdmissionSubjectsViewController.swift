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
    var formId:Int!
    var arrayDataSource = [AdmissionSubjectSectionDataSource]()
    var selectedStreamIndex:Int!
    var shouldFetchData:Bool = false //a boool value that indicates wether to fetch data when stream is selected
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AdmissionFormInputTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionCell)
        self.tableView.register(UINib(nibName: "AdmissionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.admissionHeader)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension

        setupGeneriPicker()
        addRightBarButton()
        self.getStreamdetails()
        
        
    }
    
    
    func getStreamdetails()
    {
        self.title = "Page 2/5"
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.Admission.getCampusClass
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "role_id": "\(1)",
            "admission_form_id":"\(formId ?? 0)"
        ]
        
        manager.apiPostWithDataResponse(apiName: "Get class Stream data for admission", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            do{
                let decoder = JSONDecoder()
                AdmissionSubjectManager.shared.subjectData = try decoder.decode(AdmissioSubjectData.self, from: response)
                self.makeDataSource(false)
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func getSubjectDetails( for streamClassId:Int){
        
        guard var subjectdata = AdmissionSubjectManager.shared.subjectData.admissionForm?.filter({Int($0.classMasterId ?? "") == streamClassId}).first else {
            return
        }
        
        if  subjectdata.defaultSubjectList != nil{
            AdmissionSubjectManager.shared.selectedSubject = subjectdata
            self.makeDataSource(true) //data is present no need to make API call. just reload the data
        }else{
            
            LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
            let manager = NetworkHandler()
            manager.url = URLConstants.Admission.getCampusSubject
            let parameters = [
                "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
                "role_id": "\(1)",
                "admission_form_id":"\(formId ?? 0)",
                "class_id":"\(streamClassId)"
            ]
            
            manager.apiPostWithDataResponse(apiName: "Get stream subjects data for admission", parameters:parameters, completionHandler: { (result, code, response) in
                LoadingActivityHUD.hideProgressHUD()
                do{
                    let decoder = JSONDecoder()
                    let form = try decoder.decode(AdmissionSingleFormSubjectData.self, from: response)
                    subjectdata.defaultSubjectList = form.admissionForm?.defaultSubjectList
                    AdmissionSubjectManager.shared.selectedSubject = form.admissionForm
                    AdmissionSubjectManager.shared.prepareAPIData()
//                    AdmissionSubjectManager.shared.segregateCompulsaryAndOptionalSubject()
                    self.makeDataSource(true)
                } catch let error{
                    print("err", error)
                }
            }) { (error, code, message) in
                print(message)
                LoadingActivityHUD.hideProgressHUD()
            }
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
//        if (AdmissionFormManager.shared.validateData()){
//            AdmissionFormManager.shared.sendFormOneData({ (dict) in
//                if let message  = dict?["message"] as? String{
//                    self.showAlertWithTitle("Success", alertMessage: message)
//                }
//                if let id = dict?["admission_form_id"] as? Int{
//                    self.formId = id
//                }
//            }) {
//                self.showAlertWithTitle("Failed", alertMessage: "Please Retry")
//            }
//        }else{
//            self.showAlertWithTitle("Failed", alertMessage: "Please fill up all the required text fields")
//        }
        self.performSegue(withIdentifier: Constants.segues.toRecords, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toRecords {
            if let destiationVC = segue.destination as? AdmissionAcademicRecordTableViewController{
                destiationVC.formId = self.formId ?? 0
                
            }
        }
    }

    
    @objc func donePicker(){
        self.dataPicker.isHidden = true
        self.view.endEditing(true)
        self.getSubjectDetails(for: AdmissionSubjectManager.shared.getClassMasterId(selection: self.selectedStreamIndex))
    }
    
    
    func makeDataSource(_ showSubjects:Bool){
        arrayDataSource.removeAll()
        
        if !showSubjects{
            let streamSelectionDs = AdmissionSubjectManager.shared.getProgramSelectionDataSource()
            let selectStreamHeader = AdmissionSubjectSectionDataSource(sectionType: .Program, obj: streamSelectionDs)
            arrayDataSource.append(selectStreamHeader)
        }
        else{
            let streamSelectionDs = AdmissionSubjectManager.shared.getAllProgramDatasource()
            let selectStreamHeader = AdmissionSubjectSectionDataSource(sectionType: .Program, obj: streamSelectionDs)
            arrayDataSource.append(selectStreamHeader)
        }
        
        self.tableView.reloadData()
    }
}


extension AdmissionSubjectsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataSource[section].rowCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDataSource = arrayDataSource[indexPath.section].attachedObj[indexPath.row]
        switch cellDataSource.cellType {
        case .subjectHeader,
             .programHeader:
            let cell:AdmissionHeaderTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionHeader, for: indexPath) as! AdmissionHeaderTableViewCell
            cell.setUpCell(dsObject: cellDataSource)
            return cell
            
        case .level,
             .course,
             .academicYear:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            return cell
            
        case .steam:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.setUpcell(cellDataSource)
            cell.buttonDropdown.isHidden = false
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.delegate = self
            return cell
            
            
            
            
            
        case .none:
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            return cell
            
        case .some(.subjectDetails(_)):
            let cell:AdmissionFormInputTableViewCell  = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.admissionCell, for: indexPath) as! AdmissionFormInputTableViewCell
            cell.textFieldAnswer.inputView = dataPicker
            cell.textFieldAnswer.inputAccessoryView = toolBar
            cell.textFieldAnswer.indexpath = indexPath
            cell.textFieldAnswer.delegate = self//not adding text field delegate as we dont want to change the textfield input
            cell.setUpcell(cellDataSource)
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
}
extension AdmissionSubjectsViewController:UITextFieldDelegate{
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
                        if (cellDataSource.cellType == .steam){
                            textField.text = `stringObj`
                            self.selectedStreamIndex = self.dataPicker.selectedRow
                        }
                    }
                    self.shouldFetchData = cellDataSource.cellType == .steam
                }
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
        }
        
    }
    
    
}
