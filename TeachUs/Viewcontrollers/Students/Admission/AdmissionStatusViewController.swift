//
//  AdmissionStatusViewController.swift
//  TeachUs
//
//  Created by iOS on 30/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import Photos

class AdmissionStatusViewController: BaseViewController {
    
    @IBOutlet weak var imageViewTick: UIImageView!
    @IBOutlet weak var labelSuccessMessage: UILabel!
    @IBOutlet weak var buttonDownloadDocument: UIButton!
    @IBOutlet weak var stackViewBg:UIStackView!
    @IBOutlet weak var buttonSendEmail: UIButton!
    @IBOutlet weak var textFieldEmailAddress: UITextField!
    @IBOutlet weak var imageViewCheckbox: UIImageView!
    var admissionFormData:AdmissionPdfDetails!

    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var buttonProceedToForm: UIButton!
    @IBOutlet weak var stackViewPaymentDetails: UIStackView!
    @IBOutlet weak var stackViewReceiptDetails: UIStackView!
    
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelBranchName: UILabel!
    @IBOutlet weak var labelAccountNumber: UILabel!
    @IBOutlet weak var labelIFSCCode: UILabel!
    @IBOutlet weak var labelAccountHolder: UILabel!
    @IBOutlet weak var labelUpi: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    @IBOutlet weak var textfieldTransactionNumber: UITextField!
    @IBOutlet weak var buttonUploadTransaction: UIButton!
    var imagePicker:UIImagePickerController = UIImagePickerController()
    var transactionImage:UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackViewBg.isHidden = true
        self.addGradientToNavBar()
        self.addDefaultBackGroundImage()
        buttonDownloadDocument.themeRedButton()
        buttonSendEmail.themeRedButton()
        self.stackViewBg.isHidden = true
        self.textFieldEmailAddress.delegate = self
        self.textFieldEmailAddress.addTarget(self, action: #selector(checkEmailInput), for: .editingChanged)
        self.textfieldTransactionNumber.addTarget(self, action: #selector(checkTransactionInput), for: .editingChanged)
        self.buttonUploadTransaction.themeDisabledGreyButton()
        self.buttonProceedToForm.roundedBlueButton()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        self.buttonSendEmail.themeDisabledGreyButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getFormData()
    }
    
    func getFormData(){
        AdmissionBaseManager.shared.getAdmissionPDFDetails(completion: { [weak self] (admissionOBj) in
            self?.stackViewBg.isHidden = false
            self?.setUpUIData(obj: admissionOBj)
        }) { (message) in
            self.showAlertWithTitle("Failed", alertMessage: message)
        }
        
    }
    
    func setUpUIData(obj:AdmissionPdfDetails){
        self.admissionFormData = obj
        AdmissionBaseManager.shared.formID = Int(obj.admissionFormId ?? "0")
        self.hideEverything()
        if let pdfstring = obj.pdfUrl, let pdfUrl = URL(string: pdfstring) {
            if let _ = GlobalFunction.checkIfFileExisits(fileUrl: pdfstring, name:pdfUrl.lastPathComponent){
                self.buttonDownloadDocument.setTitle("View", for: .normal)
            }
            else{
                self.buttonDownloadDocument.setTitle("Download", for: .normal)
            }
        }
        
        self.setUpBankDetails()
        
        self.labelSuccessMessage.text = AdmissionBaseManager.shared.formDetails.admissionStatusText
        self.labelSuccessMessage.isHidden = false
        self.stackViewBg.isHidden = false
        self.imageViewTick.isHidden = false

        guard  let statusString = obj.admissionStatus, let intStatus = Int(statusString) else {
            return
        }
        let status = FormStatus(rawValue: intStatus)
        switch status {
        case .processNotStarted: break //Only Status message
            //show status message only
            
        case .formIsIncomplete://Status message and Proceed button
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.errorIcon)
            self.buttonProceedToForm.isHidden = false
            
        case .formSubmitted://Status message, Download Form & Email Form
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.greenCheck)
            self.stackViewEmail.isHidden = false
            self.textFieldEmailAddress.isHidden = false
            self.buttonSendEmail.isHidden = false
            self.buttonDownloadDocument.isHidden = false
            
        case .formRejected://Only Status message
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.errorIcon)
            
        case .incompleteFormSubmitted://Status message & Proceed button
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.errorIcon)
            self.buttonProceedToForm.isHidden = false
            
            
        case .formAccepted://Status message, Bank Details, Transaction No Text Box and Upload receipt button
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.greenCheck)
            self.stackViewPaymentDetails.isHidden = false
            self.stackViewReceiptDetails.isHidden = false
            
        case .feesPaid://Only Status message.
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.greenCheck)
            
        case .incorrectfeeDetials://Status message, Bank Details, Transaction No Text Box and Upload receipt button
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.errorIcon)
            self.stackViewPaymentDetails.isHidden = false
            self.stackViewReceiptDetails.isHidden = false


        case .seatConfirmed://Only Status message
            self.imageViewTick.isHidden = false
            self.imageViewTick.image = UIImage(named: Constants.Images.greenCheck)

        case .none:
            break
        }
        
        self.buttonProceedToForm.isHidden = false
    }
    
    func hideEverything(){
        self.buttonDownloadDocument.isHidden = true
        self.imageViewTick.isHidden = true
        self.labelSuccessMessage.isHidden = true
        self.stackViewBg.isHidden = true
        self.buttonSendEmail.isHidden = true
        self.textFieldEmailAddress.isHidden = true
        self.imageViewCheckbox.isHidden = true
        self.stackViewReceiptDetails.isHidden = true
        self.stackViewEmail.isHidden = true
        self.buttonProceedToForm.isHidden = true
        self.stackViewPaymentDetails.isHidden = true
        
    }
    
    func setUpBankDetails(){
        self.labelBankName.text = "Bank Name: \(self.admissionFormData.bankDetails?.bankName ?? "")"
        self.labelBranchName.text = "Branch Name: \(self.admissionFormData.bankDetails?.branch ?? "")"
        self.labelAccountHolder.text = "Account Number: \(self.admissionFormData.bankDetails?.accountNumber ?? "")"
        self.labelIFSCCode.text = "IFSC Code: \(self.admissionFormData.bankDetails?.ifscCode ?? "")"
        self.labelAccountHolder.text = "Holder Name: \(self.admissionFormData.bankDetails?.bankName ?? "")"
        self.labelAmount.text = "Fee Amount: \(self.admissionFormData.feeAmount ?? "")"
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
    
    
    @IBAction func actionBankName(_ sender: Any) {
        UIPasteboard.general.string = self.admissionFormData.bankDetails?.bankName
    }
    @IBAction func actionBrancName(_ sender: Any) {
        UIPasteboard.general.string = self.admissionFormData.bankDetails?.branch
        
    }
    @IBAction func actionAccNumber(_ sender: Any) {
        UIPasteboard.general.string = self.admissionFormData.bankDetails?.accountNumber
    }
    @IBAction func actionIfscCode(_ sender: Any) {
        UIPasteboard.general.string = self.admissionFormData.bankDetails?.ifscCode
    }
    @IBAction func actionAccountHolderName(_ sender: Any) {
        UIPasteboard.general.string = self.admissionFormData.bankDetails?.holderName
    }
    @IBAction func actionUPI(_ sender: Any) {
        UIPasteboard.general.string = self.admissionFormData.bankDetails?.upi
    }

    
    @objc func checkEmailInput(sender:UITextField){
        if let text = sender.text{
            if(text.isValidEmailAddress()){
                self.buttonSendEmail.isEnabled = true
                self.buttonSendEmail.themeRedButton()
            }else{
                self.buttonSendEmail.isEnabled = false
                self.buttonSendEmail.themeDisabledGreyButton()
            }
        }
    }
    @objc func checkTransactionInput(sender:UITextField){
        self.buttonUploadTransaction.isEnabled = (sender.text?.count ?? 0) > 1
        if (sender.text?.count ?? 0) > 1 {
            self.buttonUploadTransaction.themeRedButton()
        }else{
            self.buttonUploadTransaction.themeDisabledGreyButton()
        }
    }
    
    @IBAction func actionAddTransactionImage(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose documents", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Camera Access Not Provided")
            
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.showAlertWithTitle("Oops!", alertMessage: "Photo Library Access Not Provided")
        }
    }
}
extension AdmissionStatusViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
extension AdmissionStatusViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.transactionImage = image
            imagePicker.dismiss(animated: true) {
                self.showAlert()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(){
        self.showAlertWithTitleAndCompletionHandlers("Confirm submission", alertMessage: "Are you sure you want to submit the receipt", okButtonString: "Confirm", canelString: "Cancel", okAction: {
            AdmissionBaseManager.shared.uploadTransactionDetails(self.textfieldTransactionNumber.text ?? "", self.transactionImage ?? UIImage(), completion: { (dict) in
                if let message  = dict?["message"] as? String{
                    self.showAlertWithTitle("Success", alertMessage: message)
                }
            }) { (message) in
                    self.showAlertWithTitle("Failed", alertMessage: message)
            }
        }) {
            //cancel clicked do nothing.
        }
    }
}
