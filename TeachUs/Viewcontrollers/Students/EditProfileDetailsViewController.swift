//
//  EditProfileDetailsViewController.swift
//  TeachUs
//
//  Created by ios on 5/19/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices

enum EditViewType {
    case EditName
    case EditEmail
    case EditMobileNumber
}


protocol EditProfileDetailsDelegate {
    func profileDetailsEdited()
}

class EditProfileDetailsViewController: BaseViewController {

    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var buttonCloseView: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelEditKey: UILabel!
    @IBOutlet weak var labelEditValue: UILabel!
    @IBOutlet weak var viewHorizontalSeperator: UIView!
    @IBOutlet weak var labelChangeKey: UILabel!
    @IBOutlet weak var viewTextfieldBg: UIView!
    @IBOutlet weak var textFieldNewValue: UITextField!
    @IBOutlet weak var viewProofBg: UIView!
    @IBOutlet weak var viewOtpBg: UIView!
    @IBOutlet weak var buttonSendOtp: UIButton!
    @IBOutlet weak var textfieldEnterOTP: UITextField!
    @IBOutlet weak var viewImageProofBg: UIView!
    @IBOutlet weak var buttonUploadProof: UIButton!
    @IBOutlet weak var labelProofOfChange: UILabel!
    @IBOutlet weak var buttonSubmitProof: UIButton!
    var studentDetails:StudentProfileDetails!
    var viewType:EditViewType?
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var chosenImage:UIImage?
    var chosenFile:URL?
    var updatedUserValue = Variable<String>("")
    var stringOtp = Variable<String>("")
    var delegate:EditProfileDetailsDelegate!
    
    var professorProfileDetails:ProfessorProfileDetails!
    var isProfessorProfileView:Bool{
        return UserManager.sharedUserManager.user! == .Professor
    }

    var myDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isOpaque = false
        if let editViewType = viewType{
            self.setUpView(type: editViewType)
        }
        self.setUpRx()
        self.buttonSubmitProof.isHidden = true
        imagePicker?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonUploadProof.roundedgreyButton()
        self.buttonSendOtp.roundedBlueButton()
        self.buttonSubmitProof.roundedBlueButton()
        self.viewTextfieldBg.makeViewCircular()
        self.viewWrapper.makeEdgesRounded()
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileDetailsViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileDetailsViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setUpRx(){
        self.textFieldNewValue.rx.text.map{ $0 ?? ""}.bind(to: self.updatedUserValue).disposed(by: myDisposeBag)
        
        self.textfieldEnterOTP.rx.text.map{$0 ?? ""}.bind(to: self.stringOtp).disposed(by: myDisposeBag)
        
        self.updatedUserValue.asObservable().subscribe(onNext: { (newText) in
            var isEntryValid:Bool = false
            switch self.viewType!{
            case .EditEmail:
                isEntryValid = GlobalFunction.isValidEmail(testStr: newText)
            case .EditMobileNumber:
                isEntryValid = newText.count == 10
            case .EditName:
                isEntryValid = newText.count > 2
            }
            
            self.viewProofBg.isHidden = !isEntryValid
        }).disposed(by: myDisposeBag)
        
        self.stringOtp.asObservable().subscribe(onNext: { (otpText) in
            self.buttonSubmitProof.isHidden = !(otpText.count == 4)
        }).disposed(by: myDisposeBag)
    }
    
    func setUpView(type:EditViewType){
        switch type {
        case .EditName:
            self.labelTitle.text = "Edit Name"
            self.labelEditKey.text = "Existing Name"
            self.labelChangeKey.text = "Change in Name"
            self.viewProofBg.isHidden = false
            self.viewOtpBg.isHidden = true
            self.viewImageProofBg.isHidden = false
            self.labelEditValue.text = isProfessorProfileView ? (self.professorProfileDetails.professorDetails?.fName ?? "") : (self.studentDetails.studentDetails?.fullName ?? "")
            self.textFieldNewValue.placeholder = "Enter Name"
            self.textFieldNewValue.keyboardType = .default
            
        case .EditMobileNumber:
            self.labelTitle.text = "Change in mobile number"
            self.labelEditKey.text = "Existing Number"
            self.labelChangeKey.text = "New number"
            self.viewProofBg.isHidden = false
            self.viewOtpBg.isHidden = false
            self.viewImageProofBg.isHidden = true
            self.labelEditValue.text = isProfessorProfileView ? (self.professorProfileDetails.professorDetails?.contact ?? "") : (self.studentDetails.studentDetails?.contact ?? "")
            self.textFieldNewValue.placeholder = "Enter Mobile Number"
            self.textFieldNewValue.keyboardType = .numberPad

        case .EditEmail:
            self.labelTitle.text = "Change in E-mail Address"
            self.labelEditKey.text = "Existing Email"
            self.labelChangeKey.text = "New E-mail"
            self.viewProofBg.isHidden = false
            self.viewOtpBg.isHidden = false
            self.viewImageProofBg.isHidden = true
            self.labelEditValue.text = isProfessorProfileView ? (self.professorProfileDetails.professorDetails?.email): (self.studentDetails.studentDetails?.email ?? "")
            self.textFieldNewValue.placeholder = "Enter Email"
            self.textFieldNewValue.keyboardType = .emailAddress
        }
    }
    
    @IBAction func closeView(_ sender:Any){
        self.dismiss(animated: true, completion: {
            if self.delegate != nil{
                self.delegate.profileDetailsEdited()
            }
        })
    }
    
    @IBAction func showImageUploadView(_ sender:Any){
        self.uploadImageProofForNameChange()
    }
    
    @IBAction func submitProof(_ sender:Any){
        switch self.viewType! {
        case .EditMobileNumber:
            self.verifyOTP(isEMailVerification: false)
            
        case .EditEmail:
            self.verifyOTP(isEMailVerification: true)
            
        case .EditName:
            self.updateName()
        }
    }
    
    @IBAction func sendOTP(_ sender:Any){
        switch self.viewType! {
        case .EditMobileNumber:
            self.sendOtp(isEMailVerification: false)
            
        case .EditEmail:
            self.sendOtp(isEMailVerification: true)
        default:
            break
        }
    }
    
    func updateName(){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        var parameters = [String:Any]()

        if var profileImage = self.chosenImage {
            let imageSizeKB = profileImage.getSizeInKb()
            print("size of image in KB: %f ", Double(imageSizeKB))
            if(imageSizeKB >= 500.0){
                do {
                    try profileImage.compressImage(400, completion: { (image, compressRatio) in
                        print(image.size)
                        profileImage = image
                    })
                } catch {
                    print("Error")
                }
                print("compressed image size = \(profileImage.getSizeInKb())")
            }
            let imageData:NSData = UIImageJPEGRepresentation(profileImage, 1)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            parameters["updated_doc"] = "\(strBase64)"
        }
        
        if let docURL = self.chosenFile{
            do {
                let docData:Data = try Data(contentsOf: docURL)
                let strBase64 = docData.base64EncodedString(options: .lineLength64Characters)
                parameters["updated_doc"] = "\(strBase64)"
            } catch let error{
                print(error)
            }
        }
        
        parameters["college_code"]  = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        parameters["existing_data"] = isProfessorProfileView ? self.professorProfileDetails.professorDetails?.fName : self.studentDetails.studentDetails?.fullName
        parameters["new_data"] = self.updatedUserValue.value
        parameters["doc_size"] = 0
        let manager = NetworkHandler()
        manager.url = isProfessorProfileView ? URLConstants.ProfessorURL.updateProfessorName : URLConstants.StudentURL.updateStudentName
        manager.apiPost(apiName: " Update user Name", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if (code == 200){
                self.dismiss(animated: true, completion: {
                    if self.delegate != nil{
                        self.delegate.profileDetailsEdited()
                    }
                })
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
            self.dismiss(animated: true, completion: {
                if self.delegate != nil{
                    self.delegate.profileDetailsEdited()
                }
            })
        }
    }
    
    func verifyOTP(isEMailVerification:Bool){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        var parameters = [String:Any]()
        parameters["college_code"]  = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        if isEMailVerification{
            parameters["email"] = "\(self.updatedUserValue.value)"
        }else{
            parameters["contact"] = "\(self.updatedUserValue.value)"
        }
        parameters["contact_password"] = self.textfieldEnterOTP.text
        let manager = NetworkHandler()
        if(isProfessorProfileView){
            manager.url = isEMailVerification ?  URLConstants.ProfessorURL.updateProfessorEmail : URLConstants.ProfessorURL.verifyOTPForNewContact
        }else{
            manager.url = isEMailVerification ?  URLConstants.StudentURL.updateStudentEmail : URLConstants.StudentURL.updateStudentMobileNumber
        }
        manager.apiPost(apiName: " verify otp ", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if (code == 200){
                self.showAlterWithTitle("Success", alertMessage: "OTP verified")
                if let newAccessToken = response["token"] as? String{
                    self.getAndSaveUserToDb(false)
                    UserManager.sharedUserManager.setAccessToken(newAccessToken)
                    self.dismiss(animated: true, completion: {
                        if self.delegate != nil{
                            self.delegate.profileDetailsEdited()
                        }
                    })
                }
                self.dismiss(animated: true, completion: {
                    if self.delegate != nil{
                        self.delegate.profileDetailsEdited()
                    }
                })
            }else{
                self.showAlterWithTitle("Error", alertMessage: "Invalid OTP")
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func sendOtp(isEMailVerification:Bool){
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        var parameters = [String:Any]()
        parameters["college_code"]  = "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)"
        if isEMailVerification{
            parameters["email"] = "\(self.updatedUserValue.value)"
            parameters["contact"] = isEMailVerification ? "\(self.professorProfileDetails.professorDetails?.contact ?? "")" :  "\(self.studentDetails.studentDetails?.contact ?? "")"
            
        }else{
            parameters["contact"] = "\(self.updatedUserValue.value)"
        }
        let manager = NetworkHandler()
        if isProfessorProfileView{
            manager.url = isEMailVerification ?  URLConstants.ProfessorURL.sendOtpForEmailUpdate : URLConstants.ProfessorURL.sendOTPForNewContact
        }
        else{
            manager.url = isEMailVerification ?  URLConstants.StudentURL.sendOtpForEmailUpdate : URLConstants.StudentURL.sendOtpForMobileNumberUpdate
        }
        manager.apiPost(apiName: " send otp ", parameters:parameters, completionHandler: { (result, code, response) in
            LoadingActivityHUD.hideProgressHUD()
            if let responseCode = response["status"] as? Int,let errorMessage = response["message"] as? String{
                if responseCode == 200{
                    self.textfieldEnterOTP.becomeFirstResponder()
                }else{
                    self.showAlterWithTitle("ERROR", alertMessage: errorMessage)
                }
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }

}

extension EditProfileDetailsViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            if(self.viewWrapper != nil){
                if((self.buttonSubmitProof.origin().y + self.viewWrapper.origin().y) >= (self.view.height()-keyboardSize.height) && self.view.frame.origin.y == 0)
                {
                    self.view.frame.origin.y -= keyboardSize.height/2
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


extension EditProfileDetailsViewController{
    func uploadImageProofForNameChange() {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
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
        
        let documentAction = UIAlertAction(title: "Document", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openDocumentPicker()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.addAction(documentAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker!, animated: true, completion: nil)
        }else{
            self.showAlterWithTitle("Oops!", alertMessage: "Camera Access Not Provided")
            
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker!, animated: true, completion: nil)
        }else{
            self.showAlterWithTitle("Oops!", alertMessage: "Photo LIbrary Access Not Provided")
        }
    }
    
    func openDocumentPicker(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

extension EditProfileDetailsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.labelProofOfChange.text = "Image Selected!"
        self.buttonSubmitProof.isHidden = false
        imagePicker?.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileDetailsViewController:UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.chosenFile = myURL
        self.buttonSubmitProof.isHidden = false
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
