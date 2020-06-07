//
//  AdmissionStatusViewController.swift
//  TeachUs
//
//  Created by iOS on 30/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class AdmissionStatusViewController: BaseViewController {
    
    @IBOutlet weak var imageViewTick: UIImageView!
    @IBOutlet weak var labelSuccessMessage: UILabel!
    @IBOutlet weak var labelDocumetnName: UILabel!
    @IBOutlet weak var buttonDownloadDocument: UIButton!
    @IBOutlet weak var stackViewBg:UIStackView!
    @IBOutlet weak var buttonSendEmail: UIButton!
    @IBOutlet weak var textFieldEmailAddress: UITextField!
    @IBOutlet weak var imageViewCheckbox: UIImageView!
    var admissionFormData:AdmissionPdfDetails!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        self.addDefaultBackGroundImage()
        buttonDownloadDocument.themeRedButton()
        buttonSendEmail.themeRedButton()
        self.stackViewBg.isHidden = true
        self.textFieldEmailAddress.delegate = self
        self.textFieldEmailAddress.addTarget(self, action: #selector(checkInput), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getFormData()
    }
    
    func getFormData(){
        self.stackViewBg.isHidden = false
        AdmissionBaseManager.shared.getAdmissionPDFDetails(completion: { [weak self] (admissionOBj) in
            self?.setUpUIData(obj: admissionOBj)
        }) { (message) in
            self.showAlertWithTitle("Failed", alertMessage: message)
        }
        
    }
    
    func setUpUIData(obj:AdmissionPdfDetails){
        self.admissionFormData = obj
        if let pdfstring = obj.pdfUrl, let pdfUrl = URL(string: pdfstring) {
            self.labelDocumetnName.text = pdfUrl.lastPathComponent
            if let _ = GlobalFunction.checkIfFileExisits(fileUrl: pdfstring, name:pdfUrl.lastPathComponent){
                self.buttonDownloadDocument.setTitle("View", for: .normal)
            }
            else{
                self.buttonDownloadDocument.setTitle("Download", for: .normal)
            }
        }
        self.labelSuccessMessage.text = AdmissionBaseManager.shared.formDetails.admissionStatusText
    }
    
    @IBAction func actionDownloadDocument(_ sender: Any) {
        if let pdfString = self.admissionFormData.pdfUrl, let pdfUrl = URL(string: pdfString){
            let generatedFileName = pdfUrl.lastPathComponent
            let imageURL = "\(pdfString)"
            if let filePath = GlobalFunction.checkIfFileExisits(fileUrl: imageURL, name:generatedFileName){
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.viewControllerId.documentsVC) as! DocumentsViewController
                viewController.filepath = filePath
                viewController.fileURL = imageURL
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{// save file
                if let window = UIApplication.shared.keyWindow{
                    LoadingActivityHUD.showProgressHUD(view: window)
                }
                GlobalFunction.downloadFileAndSaveToDisk(fileUrl: imageURL, customName: generatedFileName) { (success) in
                    LoadingActivityHUD.hideProgressHUD()
                    DispatchQueue.main.async {
                        self.buttonDownloadDocument.setTitle("View", for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func actionEmailForm(_ sender: Any) {
        AdmissionBaseManager.shared.emailPDF(self.textFieldEmailAddress.text ?? "", completion: { (dict) in
            if let message  = dict?["data"] as? String{
                self.showAlertWithTitle("Success", alertMessage: message)
            }
        }) { (message) in
            self.showAlertWithTitle("Failure", alertMessage: message)
        }
    }
    
    @objc func checkInput(sender:UITextField){
        if((sender.text?.isValidEmailAddress()) != nil){
            self.buttonSendEmail.isEnabled = true
            self.buttonSendEmail.themeRedButton()
        }else{
            self.buttonSendEmail.isEnabled = false
            self.buttonSendEmail.themeDisabledGreyButton()

        }
    }
}
extension AdmissionStatusViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
